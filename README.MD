# A kotlin build automation system

## Implementations

Current implementation is for Mac OS (Darwin) and GNU Linux

## To-do

* Create a `./Libraries` folder and add the jar dependencies to the root of this folder (Only create `./Libraries` if you
  intend to add libraries
  
* Only create subfolders at one level. i.e only `./Sources/*/*` and not `./Sources/*/*` or higher levels

## Usage

The usage is as follows

| Task                    | Command |
|--------------------------|:--------:|
| **Build** | ```bash
 bash ./script.sh bl 
 ``` |
| **Debug** |	```bash
  bash ./script.sh dl # you can replace dl with rl
  ``` |
| **Run existing build** | ```bash
  bash ./script.sh r
  ```    |

