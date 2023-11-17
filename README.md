[![build](https://github.com/Barnard-PL-Labs/tsltools/actions/workflows/action.yml/badge.svg)](https://github.com/Barnard-PL-Labs/tsltools/actions/workflows/action.yml)

# TSL Tools

A tool set and library for processing and synthesizing [Temporal Stream Logic
(TSL)](https://www.react.uni-saarland.de/publications/FKPS19a.html)
specifications. 

1. [Tool Overview](#tool-overview)
    1. [Analyzing TSL Specifications](#analyzing-tsl-specifications)
    2. [Processing TSL Specifications](#processing-tsl-specifications)
    3. [Generating Control Flow Models](#generating-control-flow-models)
    4. [Debugging TSL Specifications](#debugging-tsl-Specifications)

2. [Installation](#installation)
3. [Research and Documentation](#research-and-documentation)
4. [Contributing](#contributing)

# Tool Overview

To run full pipeline synthesis, use the `tsl synth` command.
This takes a TSL spec and outputs a controller programmed in the specified target language.
For a quick test, you can run:

```tsl synth -i test/res/specs/Heating.tsl --python```

The precise usage and arguments for each tool are describe by
`tsl --help` and `tsl <subcommand> --help`. Note that most subcommands
will try to read some file from `STDIN` when they get no specific input.

Note that you will still need an LTL synthesis engine. 
See [Installation](#installation) for further instructions.

## Processing TSL Specifications

The synthesis pipeline has the following passes:
1. 'preprocess': convert a TSL specification with full syntax to a TSL specification with base syntax.
2. 'theorize': generate assumptions for the theory that the TSL specificaiton is using.
3. 'tlsf': under-approximate the TSL specification in TLSF.
4. 'hoa': synthesize the TLSF specification with user-provided `ltlsynt` into a controller in HOA format.
5. 'synthesize': generate controller program in target programming language.

The names of each pass also corresponds to a subcommand of the `tsl` executable, which
outputs the artifact processed at that pass. For example, `tsl preprocess` takes a TSL
specification with full syntax and outputs the specification in base syntax; on the other hand,
`tsl hoa` takes the TSL specification with full syntax and outputs the synthesized controller
in HOA format.

Therefore, to run the full pipeline, use the `tsl synthesize` command.

## Debugging TSL Specifications

* UPCOMING: `tslplay` allows to play against a environment strategy (system strategy) 
  as the system (environment) interactively. `tslplay` shows why some options
  are not available to the user according to the respective specification 
  helping to understand why some specification are unrealizable.
* `tsl coregen` generate so called *TSL unrealizability cores*, i.e. the minimal
  amount of guarantees of some specification that render it unrealizable. Can 
  be run with e.g. `tsl coregen -i spec.tsl`.
* `tsl minrealizable` generate so called *minimal assumption cores*, i.e. the 
  minimal amount of assumptions of some specification that render it realizable.

# Installation

We use the [Haskell Tool Stack](http://haskellstack.org/)
for building. The tool automatically pulls the required version of the 
Glasgow Haskell Compiler (GHC) and all required dependencies. Note that by 
using `stack`, the installation does not interfere with any system 
installation. After `stack` is installed, when in the main project directory,
you can try the `tsl` command with:

```shell
stack run -- tsl SUBCOMMAND
```

If you want to install the `tsl` command to you system, you can use:
```shell
stack install
# OR, if you want to specify a custom installation destination:
stack install --local-bin-path SOMEPATH
```

You will also need to install an LTL synthesis engine.
Recommended options are [ltlsynt](https://spot.lrde.epita.fr/ltlsynt.html)
or [Strix](https://strix.model.in.tum.de/).
`ltlsynt` is packaged with [`spot`](https://spot.lrde.epita.fr/).

# Research and Documentation

* [The original paper](https://www.react.uni-saarland.de/publications/FKPS19a.html)
  and its 
  [extended version](https://arxiv.org/abs/1712.00246)
* [The FRP paper](https://www.react.uni-saarland.de/publications/FKPS19b.html) 'Synthesizing Functional Reactive Programs'
* A FPGA arcade game specified using TSL, 
  [syntroids](https://www.react.uni-saarland.de/casestudies/syntroids/)
* **WIP**: A tool-paper describing the format and other features of `tsltools`.

If you want to contribute please refer to [CONTRIBUTING](./CONTRIBUTING.md).
