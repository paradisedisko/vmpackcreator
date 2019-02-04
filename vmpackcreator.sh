#!/bin/sh

SCRIPT_DIR=$(dirname "$0")

VERSION="1.0"

TEMP="./VMPACKBUILDER_TEMP"

final_property_file_name=vm.properties
windows_property_file=`$SCRIPT_DIR/rel2abspath $SCRIPT_DIR/vm.prop.win`
linux_property_file=`$SCRIPT_DIR/rel2abspath $SCRIPT_DIR/vm.prop.lin`
osx_property_file=`$SCRIPT_DIR/rel2abspath $SCRIPT_DIR/vm.prop.osx`

WINDOWS="Windows"
LINUX="Linux"
OSX="OSX"

pwd=`pwd`

platform=$1
path_to_vm_packs=$2
path_to_existing_jre=$3
vm_pack_name=$4

clean_up() {
  rm -f $TEMP
}

err_msg() {
  echo "$@" 1>&2
  exit
}

init() {
    path_to_vm_packs=`$SCRIPT_DIR/rel2abspath $path_to_vm_packs`
	path_to_vm_packs="$path_to_vm_packs"/
	path_to_existing_jre=`$SCRIPT_DIR/rel2abspath $path_to_existing_jre`
	path_to_existing_jre="$path_to_existing_jre"/

	if [ ! -d $path_to_vm_packs ]
	then
		mkdir $path_to_vm_packs
	fi

    if [ -d $path_to_vm_packs  ]
    then
        cd $path_to_vm_packs
    else
        err_msg "No path to VM! Aborting..."
    fi

    if [ ! -d $path_to_existing_jre ]
    then
        err_msg "JRE does not exist in $path_to_existing_jre! Aborting..."
    fi
}

buildvm_windows() {
    touch $final_property_file_name
    if [ -f $final_property_file_name ] && [ -f $windows_property_file ]
    then
        vm_prop_generated
    else
        err_msg "Couldn't find $windows_property_file or $final_property_file_name"
    fi

    cat $windows_property_file > $final_property_file_name
    mkdir jre

    cp -r "$path_to_existing_jre"* "$path_to_vm_packs"jre/

    clean_up

    jre_copied

    cd $path_to_vm_packs
    zip -0r "$path_to_vm_packs"vm * > $TEMP

    if [ -f vm.properties ] && [ -f vm.zip ]
    then
        vm_pack_prep

        zip -9 "$vm_pack_name".vm vm.properties vm.zip > $TEMP

        clean_up

        {
            rm -rvf jre/ && rm -rvf vm.properties && rm -rvf vm.zip
        } > $TEMP

     else
        err_msg "vm.properties and vm.zip needed but not found! Aborting..."
     fi

    operation_done
    clean_up_exit
}

vm_pack_prep() {
	echo "Packing all resources into final VM pack..."
}

clean_up_exit() {
	rm -f $TEMP
	exit 1
}

jre_copied() {
	echo "Packing JRE..."
}

vm_prop_generated() {
	echo "vm.properties file generated."
	echo "Copying JRE..."
}

operation_done() {
	echo "VM pack was successfully created. Access it in: $path_to_vm_packs"
}

buildvm_linux() {
	echo "Generating $LINUX platform VM pack:"
    if [ -f $final_property_file_name ] && [ -f $linux_property_file ]
    touch $final_property_file_name
    then
        vm_prop_generated
    else
        err_msg "Couldn't find $linux_property_file or $final_property_file_name"
    fi
    cat $linux_property_file > $final_property_file_name
    mkdir jre

    cp -r "$path_to_existing_jre"* "$path_to_vm_packs"jre/

    clean_up

    jre_copied

    cd $path_to_vm_packs
    tar -czf "$path_to_vm_packs"vm.tar.Z jre/ > $TEMP

    clean_up

    if [ -f vm.properties ] && [ -f vm.tar.Z ]
    then
        vm_pack_prep

        zip -9 "$vm_pack_name".vm vm.properties vm.tar.Z > $TEMP

        clean_up

        {
            rm -rvf jre/ && rm -rvf vm.properties && rm -rvf vm.tar.Z
        } > $TEMP

     else
        err_msg " vm.properties and vm.zip needed but not found! Aborting..."
     fi

    operation_done
    clean_up_exit
}

if [ $# -ne 4 ]
then
	echo "Usage: vmpackcreator <platform> <destination dir> <path to existing JRE> <filename of VM pack>"
	exit 0
fi


echo "VM Pack Creator $VERSION"
echo "...using the following parameters:"
echo "Platform: $platform"
echo "JRE path: $path_to_existing_jre"
echo "VM path: $path_to_vm_packs"
echo "VM name : $vm_pack_name"

echo $SCRIPT_DIR

echo $windows_property_file

init

case "$platform" in
    $WINDOWS)
        buildvm_windows ;;

    $LINUX)
        buildvm_linux ;;
esac
