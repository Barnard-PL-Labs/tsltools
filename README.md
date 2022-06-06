[![build](https://github.com/Barnard-PL-Labs/tsltools/actions/workflows/action.yml/badge.svg)](https://github.com/Barnard-PL-Labs/tsltools/actions/workflows/action.yml)

# TSL Tools

A tool set and library for developing and processing [Temporal Stream Logic
(TSL)](https://www.react.uni-saarland.de/publications/FKPS19a.html)
specifications and Control Flow Models (CFMs) that result from TSL
synthesis. 

1. [Tool Overview](#tool-overview)
    1. [Analyzing TSL Specifications](#analyzing-tsl-specifications)
    2. [Processing TSL Specifications](#processing-tsl-specifications)
    3. [Generating Control Flow Models](#generating-control-flow-models)
    4. [Debugging TSL Specifications](#debugging-tsl-Specifications)

2. [Installation](#installation)
3. [Research and Documentation](#research-and-documentation)
4. [Contributing](#contributing)

# Tool Overview

To run full pipeline synthesis, use the `tslsynth` tool.
This takes a TSL spec and generates a .code file in the specified target language.
For a quick test, you can run:

```./tslsynth src/test/res/specs/Heating.tsl --python```

The precise usage and arguments for each tool are describe by 
`<toolname> --help`. Note that most tools will try to read some file 
from `STDIN` when they get no specific input.

Note that you will still need an LTL synthesis engine. 
See [Installation](#installation) for further instructions.

## Analyzing TSL Specifications

* `tslcheck` checks for a set of TSL specification files, whether they are 
  valid or not.
* `tslsym` prints the symbol table that is derived from a TSL specification. 
  The table identifies all inputs, outputs, function, and predicate symbols, 
  as well as their derived type signatures. Therefore, the tool provides a 
  first overview of specified modules. It is, however, also useful to 
  identify typos in the literals used, since they are automatically 
  introduced by their usage and, thus, do not lead to an error if spelled 
  incorrectly.
* `tslsize` prints the size of the specification, i.e., the number of AST nodes
  of the underlying TSL formula. It can be used for comparing a set of TSL 
  benchmarks.

## Processing TSL Specifications

* `tslsynt` runs full-pipeline synthesis, from spec to code.
* `tsl2tlsf` under-approximates a TSL specification by a weaker LTL 
  specification that is given in the [TLSF](https://arxiv.org/abs/1604.02284)
  format.
* `tslresolve` resolves TSL specifications with imports into a plain TSL
  specifications by inlining the imported specifications.
* `tslsplit` applies a sound specification decomposition technique to the give 
  specification. It assumes unrealizability of the negated assumptions (such
  that the spec is not realizable by assumption violation). It saves the 
  resulting specs as `<filename>_x.tsl` in the current path where `x` is the 
  index of the respective subspecification.
* `tsl2toml` transforms a TSL file into [TOML](https://toml.io/)
  file of TSL formulas.
* `parsehoa` processes the hoa file generated by an LTL synthesis engine into a human readable form.
  Must be passed a .hoa file synthesized from a .tlsf file, which was in turn generated with tsl2tlsf.
  Can then be visualized with `autfilt` from the `spot` toolset.

## Generating Models

* `hoa2code` generates executable code from a valid hoa file. No target available yet.
* `cfmcheck` checks for a set of CFM files, whether they are valid or not.
* `cfmsym` prints the symbol table of a CFM, similar to `tslsym` printing the
  symbol table for a TSL specification.
* `cfminfo` prints the number of inputs, outputs, predicates, functions, cells,
  and vertices of the generated CFM.
* `cfm2code` generates executable code from a valid CFM. To this end, a 
  specific code target must be selected. Supported targets are:
    * `applicative`: generates code for Applicative FRP libraries 
    * `monadic`: generates code for Monadic FRP libraries
    * `arrow`: generates code for Arrowized FRP libraries
    * `clash`: generates code for the hardware description language 
      [CλaSH](https://clash-lang.org/)

## Debugging TSL Specifications

* `tslplay` allows to play against a environment strategy (system strategy) 
  as the system (environment) interactively. `tslplay` shows why some options
  are not available to the user according to the respective specification 
  helping to understand why some specification are unrealizable. The strategies
  are in the form of a CFM.
* `tslcoregen` generate so called *TSL unrealizability cores*, i.e. the minimal
  amount of guarantees of some specification that render it unrealizable.
* `tslminrealizable` generate so called *minimal assumption cores*, i.e. the 
  minimal amount of assumptions of some specification that render it realizable.

# Installation

We recommend using the [Haskell Tool Stack](http://haskellstack.org/)
for building. The tool automatically pulls the required version of the 
Glasgow Haskell Compiler (GHC) and all required dependencies. Note that by 
using `stack`, the installation does not interfere with any system 
installation. After `stack` is installed just type

`make`

in the main directory to build TSL tools.

You will also need to install an LTL synthesis engine.
Recommended options are ltlsynt (https://spot.lrde.epita.fr/ltlsynt.html)
or Strix (https://strix.model.in.tum.de/).
`ltlsynt` is packaged with `spot` (https://spot.lrde.epita.fr/)

There is a legacy visualizer tool, `parsehoa`. This has a required dependency `autfilt`, which comes with `spot`.
If you use `autfilt` from the `spot` package to visualize code, you will then also need the `syfco` tool.
To install, follow the directions at the repo here: https://github.com/reactive-systems/syfco and `stack install`.
A beta visualization tool is also supported - use the target `--xstate` to generate xstate code then paste it into `https://stately.ai/viz`.

# Research and Documentation

* [The original paper](https://www.react.uni-saarland.de/publications/FKPS19a.html)
  and its 
  [extended version](https://arxiv.org/abs/1712.00246)
* [The FRP paper](https://www.react.uni-saarland.de/publications/FKPS19b.html) 'Synthesizing Functional Reactive Programs'
* A FPGA arcade game specified using TSL, 
  [syntroids](https://www.react.uni-saarland.de/casestudies/syntroids/)
* **WIP**: A tool-paper describing the format and other features of `tsltools`.

If you want to contribute please refer to [CONTRIBUTING](./CONTRIBUTING.md).
