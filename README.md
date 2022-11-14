# diploma-master

[![Lint](https://github.com/andinoriel/diploma-master/actions/workflows/lint.yml/badge.svg)](https://github.com/andinoriel/diploma-master/actions/workflows/lint.yml)

This diploma project designed to interactively demonstrate the key aspects of modern encryption algorithms with an assessment of their effectiveness.

## Usage

1. Install [Docker](https://docs.docker.com/engine/installation/), [Docker Compose](https://docs.docker.com/compose/install/) and [Task](https://taskfile.dev/#/installation);

2. Clone this project and then cd to the project folder;

3. Run the initial build of the environment:
```sh
$ task init
```

4. Now you just need to run the application:
```sh
$ task run
```

5. After finishing work, you can stop running containers:
```sh
$ task stop # to just stop running application
$ task down # also stop and remove containers
```

## Screenshots

<details>
  <summary>Expand</summary>

  <p align="center">
    <img src="screenshots/1.png" width="1280"/>
    <img src="screenshots/2.png" width="1280"/>
    <img src="screenshots/3.png" width="1280"/>
    <img src="screenshots/4.png" width="1280"/>
    <img src="screenshots/5.png" width="1280"/>
    <img src="screenshots/6.png" width="1280"/>
    <img src="screenshots/7.png" width="1280"/>
    <img src="screenshots/8.png" width="1280"/>
    <img src="screenshots/9.png" width="1280"/>
    <img src="screenshots/10.png" width="1280"/>
    <img src="screenshots/11.png" width="1280"/>
    <img src="screenshots/12.png" width="1280"/>
    <img src="screenshots/13.png" width="1280"/>
    <img src="screenshots/14.png" width="1280"/>
    <img src="screenshots/15.png" width="1280"/>
    <img src="screenshots/16.png" width="1280"/>
    <img src="screenshots/17.png" width="1280"/>
    <img src="screenshots/18.png" width="1280"/>
  </p>
</details>

## Samples

For the examples of finished csv and bench report see [csv](samples/data2022-11-08_08-49-35.csv), [log](samples/vcbench2022-11-08_08-49-35.log).

## Credits

My thanks to the developers of the [Docker](https://www.docker.com/company), [Bash](https://www.gnu.org/software/bash/) and [VeraCrypt](https://www.veracrypt.fr/code/VeraCrypt/).

## License

This project is licensed under the [MIT License](LICENSE).
