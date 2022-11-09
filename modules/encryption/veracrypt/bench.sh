#!/bin/bash

# =================================================================
#
#   SUBMODULE: veracrypt:bench
#   LOCAL ENTRY POINT: modules_encryption_veracrypt_bench
#
#   veracrypt
#   |-- veracrypt.sh
#   |-- bench.sh *CURRENT*
#   |-- encryption.sh
#   |-- decryption.sh
#
#   COMMENT: encryption:veracrypt benchmarking
#
# =================================================================

source $PROJ_ROOT_DIR/utility/utility.sh

unwrap_time_to_sec() {
  [[ $unwrapped_time =~ ([0-9]+m) ]] && minutes="${BASH_REMATCH[1]::-1}"
  [[ $unwrapped_time =~ ([0-9]+\.[0-9]{3}) ]] && seconds="${BASH_REMATCH[1]}"

  retval=$(python3 -c "print($minutes*60+$seconds, end='')")
}

modules_encryption_veracrypt_bench_inner() {
  #region ROOT IS REQUIRED

  local size=(1073741824) # 50MB 100MB 200MB 500MB 1GB 52428800 104857600 209715200 524288000
  local hash=(SHA-256 RIPEMD-160 SHA-512 Whirlpool Streebog)
  local encalg=(AES Camellia Kuznyechik Serpent Twofish AES-Twofish AES-Twofish-Serpent Camellia-Kuznyechik Camellia-Serpent Kuznyechik-AES Kuznyechik-Serpent-Camellia Kuznyechik-Twofish Serpent-AES Serpent-Twofish-AES Twofish-Serpent)

  local cpu_info=$(< /proc/cpuinfo grep -oP "model name.*?:(.*)" | uniq | sed "s/model name.*: //")

  local time_start=$(date "+%Y-%m-%d %k:%M:%S")
  local time_start_unix=$(date +%s)

  local separator="-----------------------------------------------------------------------------------------------------------------------"

  echo "$separator"
  echo "- Bench VeraCrypt"
  echo "- Started at: $time_start"
  echo "- CPU: $cpu_info"
  echo "$separator"
  printf "%-10s | %-10s | %-30s | %-20s | %-20s | %-10s\n" \
    "SIZE" "HASH" "ENCRYPTION ALGORITHM" \
    "VOL CREATE TIME" "VOL FILL TIME" "SPEED (MB/sec)"

  echo "$separator"

  local mntdir=$PROJ_ROOT_DIR/out/mnt/vc/
  local benchdir=$PROJ_ROOT_DIR/out/bench/vc/
  mkdir -p "$mntdir"
  mkdir -p "$benchdir"

  local csvfile="$PROJ_ROOT_DIR/out/data$(date +%F_%H-%M-%S).csv"
  echo "size,hash+algorithm,total time,speed(mb/s)" >> "$csvfile"

  for current_size in "${size[@]}"; do
    for current_hash in "${hash[@]}"; do
      for current_encalg in "${encalg[@]}"; do
        local password=$(
          tr </dev/urandom -dc _A-Z-a-z-0-9 | head -c"${1:-64}"
          echo
        )

        local container_name="$benchdir/vcc$(date +%F_%H-%M-%S).vc"

        # creating vc volume and time it
        local volume_create_time=$( (time (veracrypt -m=nokernelcrypto -t --size="$current_size" --password="$password" -k "" \
          --random-source=/dev/urandom --volume-type=normal \
          --encryption="$current_encalg" --hash="$current_hash" --filesystem=FAT \
          --pim=0 -c "$container_name")) 2>&1 |
          grep -i "real" | sed "s/real//" | sed "s/ //g" | tr "\t" " ")

        # mount created volume
        veracrypt -m=nokernelcrypto -t --pim=0 --keyfiles="" --protect-hidden=no \
          --password="$password" --mount "$container_name" "$mntdir"

        local fill_time_start=$(date +%s)

        local file_count=$(($current_size / 26214400 - 1))

        # fill the container with 25 MB files and time it
        local volume_fill_time=$( (time (for ((i = 1; i <= $file_count; i++)); do
          dd if=/dev/urandom of="$mntdir/$i.dat" \
          bs=26214400 count=1
        done)) 2>&1 | grep -i "real" | sed "s/real//" | sed "s/ //g" | tr "\t" " ")

        local fill_time_end=$(date +%s)

        # calc write speed
        local elapsed_fill_time=$(($fill_time_end - $fill_time_start))
        if [ $elapsed_fill_time -eq 0 ]; then
          elapsed_fill_time=1
        fi
        local elapsed_fill_speed=$(($file_count * 26214400 / $elapsed_fill_time / 1024 / 1024))

        # output
        printf "%-10s | %-10s | %-30s | %-20s | %-20s | %-10s\n" \
          "$((current_size / 1024 / 1024)) MB" "$current_hash" "$current_encalg" \
          "$volume_create_time" "$volume_fill_time" "$elapsed_fill_speed"

        unwrapped_time=$volume_create_time
        unwrap_time_to_sec "\${unwrapped_time}"
        volume_create_time=$retval

        unwrapped_time=$volume_fill_time
        unwrap_time_to_sec "\${unwrapped_time}"
        volume_fill_time=$retval

        total_time=$(python3 -c "print(round($volume_create_time + $volume_fill_time, 3))")

        echo "$((current_size / 1024 / 1024)),$current_hash--$current_encalg,$total_time,$elapsed_fill_speed" >> $csvfile

        # unmount created volume
        veracrypt -m=nokernelcrypto -t -d "$container_name"

        rm -f "$container_name"

      done
    done
  done

  rm -rf "$mntdir"
  rm -rf "$benchdir"

  echo "$separator"

  local time_end_unix=$(date +%s)
  local elapsed_time=$((${time_end_unix} - ${time_start_unix}))
  local elapsed_time=$(date -d@$elapsed_time -u +%H:%M:%S)

  echo "- Completed on: $(date "+%Y-%m-%d %k:%M:%S")"
  echo "- Elapsed Time: $elapsed_time"
  echo "$separator"

  #endregion
}

modules_encryption_veracrypt_bench() {
  #region ROOT IS REQUIRED

  SUDO_CRED_LOCK_RESET

  source $PROJ_ROOT_DIR/utility/common.sh dialog_get_sup
  [[ $? -eq "$RC_ERROR" ]] && return
  rpass=$retval

  local log=$PROJ_ROOT_DIR/out/vcbench$(date +%F_%H-%M-%S).log
  sudo -E -S -k -p "" bash -c \
    "$(declare -f modules_encryption_veracrypt_bench_inner);$(declare -f unwrap_time_to_sec);modules_encryption_veracrypt_bench_inner" \
    <<<"$rpass" | tee "$log" | $DIALOG --progressbox 80 125
  $DIALOG --textbox "$log" 80 125

  rm -f "$log"

  SUDO_CRED_LOCK_RESET

  #endregion
}

RESOLVE_FUNC_CALL "$@"
