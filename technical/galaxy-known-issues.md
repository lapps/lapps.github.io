---
layout: default
title: Installing LAPPS/Galaxy - known issues
---


# Known issues when installing LAPPS/Galaxy

This page has some known issues when installing a LAPPS/Galaxy instance as well as the workarounds. The following issues are discussed:

- Logging error: logging.getLogger does not exist
- Missing migration scripts
- Updating the tool menu


### Logging error: logging.getLogger does not exist

In some cases on startup you get an error that a logging method is not available. This happens when you have the following configuration in the galaxy code:

```
lib/galaxy/util/submodules.py
lib/galaxy/util/logging/
```

The `submodules` script uses the Python `logging` module but because of the `logging` directory it cannot find it. There is nothing of value in the `logging` directory and it is there only because at some point you installed an instance from another branch of the galaxy code.

**Solution**: remove the `logging` directory.


### Missing migration scripts

You may see the following error:

```
AssertionError: There is no script for 136 version
```

This error occurs in `/Applications/ADDED/galaxy/galaxy/lib/galaxy/model/migrate/check.py`. Like the previous case, this can happen when you have switched between several branches or commits and a previous version leaves some pyc files. The `check.py` script runs a bunch of migrate scripts that update the database and it gets confused when there are `pyc` files that do not have a corresponding `py`file.

Migrate scripts are in `/lib/galaxy/model/migrate/versions`. In one case this directory had `pyc` and `py` script for all migration scripts up to number 135, but it also included

```
0136_collection_and_workflow_state.pyc
0137_add_copied_from_job_id_column.pyc
0138_add_hda_version.pyc
0139_add_history_dataset_association_history_table.pyc
0140_add_dataset_version_to_job_to_input_dataset_association_table.pyc
0141_add_oidc_tables.pyc
0142_change_numeric_metric_precision.pyc
```

**Solution**: remove those pyc files.


### Updating the tool menu

The tool menu is changed by editing `GalaxyMods/config/tool_conf.xml`. When you do this on a running instance (at least with a local install) then refreshing the screen in your browser will actually give you a new menu. However, this does not work for all changes. For example, if you move a section of tools then nothing happens. This is because when you start an instance Galaxy will create a file named `integrated_tool_panel.xml` in the root directory. This file is used by the running instance to create the menu (after a refresh) and changing `tool_conf.xml` will change it. For example, tools in a section will be removed. But what will not change is the list of top-level sections and the order of them, only tool elements of those sections will be added, changed or removed.

This is not a problem when you remove an entire section in `tool_conf.xml`, it will still be in `integrated_tool_panel.xml`, but it will be empty and won't be displayed.

**Solution**. If you need to change the order of the sections you have to remove `integrated_tool_panel.xml` and restart the instance.
