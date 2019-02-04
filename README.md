# createvmpackage

## About

Creates Install Anywhere VM packages (.vm) for Windows, Linux and OSX.

## Download


## Usage

Invoking createvmpackage from the command line may look like this:

```bash
createvmpackage <plaform> <destination dir> <path to existing JRE> <filename of VM pack>"  
```
| Parameter | Meaning |
| --- | --- |
| platform | one of "Windows", "Linux", "OSX" |
| destination dir | directory where the VM packs will be created |
| path to existing JRE | directory where a JRE exists for bundling into VM pack |
| filename of VM pack | the filename (YOURNAME.vm) of the final VM pack |


## Limitations

  * No support for other platforms

## License & Contributions

The code is licensed under the [Apache 2 license](http://www.apache.org/licenses/LICENSE-2.0.html). By contributing to this repository, you automatically agree that your contribution can be distributed under the Apache 2 license by the author of this project. You will not be able to revoke this right once your contribution has been merged into this repository.

## Security

Distributing a bundled JVM has security implications, just like bundling any other runtimes like Mono, Air, etc. 
Make sure you understand the implications before deciding to use this tool.

