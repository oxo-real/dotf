# neomutt config files, information and organization

## 1. account config
holds the email account settings, for (one!) specific email account

<account_config_file> location:
$XDG_CONFIG_HOME/neomutt/<email_domain_name>/<email_user_name>/account_config

file is called when starting neomutt in terminal cli via its '-F' option:
```neomutt -F <account_config_file>```

## 2. main config
holds the general neomutt application settings, for all account configs

<main_config_file> location:
$XDG_CONFIG_HOME/neomutt/main_config

the main neomutt configuration is sourced
in the very first lines of the <account_config_file>

## 3. specific config
hold specific settings, like keybindings, macros, encryption and colors

specific configs files are:
$XDG_CONFIG_HOME/neomutt/color_config
$XDG_CONFIG_HOME/neomutt/gpg_config
$XDG_CONFIG_HOME/neomutt/key_config

the specific configs are sourced in the very end of the <main_config_file>

## 4. summary
summarizing the cascading configuration:

<account_config_file>	-->
								<main_config_file>	-->
															<color_config>
															<gpg_config>
															<key_config>
