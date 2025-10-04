# [CodeClash] Core War
This is the starter codebase for the Core War arena featured in CodeClash.

The code represented in this codebase comes from the following sources:
- https://corewar.co.uk/pmars.htm: This is the main page hosting download-able assets for Core War.
- https://corewar.co.uk/pmars/pmars-0.9.4.zip: From the above page, this is the specific version of CoreWar we use.

As RedCode is a domain-specific language, we make an effort to provide resources to help players understand how to write RedCode programs:
- https://corewar.co.uk/karonen/guide.htm: This corresponds to the `doc/guide.htm` file
- https://github.com/corewar/corewar.io: This repository is a modernized, JavaScript based Core War simulator.
    - We do *not* use the simulator or code from this repository to avoid mixing implementations, with the exception of the [`docs/`](https://github.com/corewar/corewar.io/tree/master/docs/redcode) folder.
        - We remove the `developer/` subfolder, as it contains discrepancies specific to their simulator that does not apply to the pMARS implementation.
        - We co-locate all the assets under the `doc/` folder.
    - The docs are also hosted online at https://corewar-docs.readthedocs.io/en/latest/.
- Last but not least, we also supply documentation around strategy for Core War. We use the following script to crawl the `corewar.co.uk/strategy.htm` page and its immediate sub-pages. The contents downloaded are then relocated under the `doc/strategy/` folder.

```bash
#!/bin/bash
wget --recursive --level=1 --no-clobber --accept=htm,html \
  --domains corewar.co.uk --no-parent \
  https://corewar.co.uk/strategy.htm
```