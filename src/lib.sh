#!/usr/bin/env bash

source src/array.sh
source src/string.sh
source src/variable.sh
source src/file.sh
source src/misc.sh
source src/date.sh
source src/interaction.sh
source src/check.sh
source src/format.sh
source src/collection.sh
source src/json.sh
source src/terminal.sh
source src/validation.sh
source src/debug.sh
source src/os.sh

lib::install() {
	if check::command_exists $2; then
		echo "$1 is already installed"
	else
		if interaction::prompt_yes_no "Do you want to install $1" "yes"; then
			echo "Installing!"
			($3)
		else
			echo "Skipping!"
		fi
	fi
}

lib::setup() {
	if check::command_exists $2; then
		if interaction::prompt_yes_no "Do you want to setup $1" "yes"; then
			echo "Installing!"
			($3)
  		echo "Setup Successfully!"
		else
			echo "Skipping!"
		fi
	fi
}

lib::tool() {
	if check::command_exists $2; then
		if interaction::prompt_yes_no "Do you want to install $1" "no"; then
			echo "Installing!"
			($3)
		else
			echo "Skipping!"
		fi
  else
		echo "$2 command not found!"
	fi
}

lib::pack() {
	if interaction::prompt_yes_no "Do you want to install $1" "yes"; then
		echo "Starting!"
		($2)
		echo "Finished!"
	else
		echo "Skipping!"
	fi
}

