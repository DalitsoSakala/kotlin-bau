#!/bin/bash
# Author: Dalitso Sakala
# Url: https://github.com/dalitsoSakala/mbcc.git

#
#
#	Directory structure is
#						./Libraries/*.jar	(Dependencies)
#						./Libraries/temp	(Temporarily generated library build directory)
#						./Libraries/out/libs.jar (Autogenerated)
#						./Sources/main.kt		(Entry)
#						./Sources/*/*.kt		(Other files)
#						./Debug.jar		(Compiled debug file)
#						./script.sh		(This file)
#						./<App.jar>		(Build output)
#						./temp			(Temporarily generated build directory)
#
ROOT=$(pwd)
sourcesDir=Sources
defaultDebugFileName=Debug
defaultBuildFileName=App
function build(){
	classPathScript=-cp $ROOT/Libraries/out/libs.jar
	cd $ROOT
	if [[ ! -d Libraries ]]; then
		classPathScript=""
	fi
	echo "building source packages"
	cd $sourcesDir
	`
	kotlinc -include-runtime $classPathScript  -d $ROOT/$defaultBuildFileName.jar  main.kt */*.kt
	`
	cd $ROOT
	echo "done."
}



function run(){
	cd $ROOT
	echo run without build
	arg=$defaultBuildFileName
	if [[ -n $1 ]]; then
		arg=$1 ; fi
	`
	kotlin  $arg.jar
	`
	echo "done"
}

function lib-build(){
	echo building dependencies
	
	cd $ROOT/Libraries
	files=$(dir)
	mkdir -p temp;cd temp
	for file in $files;do
		if [ -x ../$file  ]; then echo
		else	
			`jar xf ../$file`
		fi
	done
	mkdir -p ../out
	jar cf ../out/libs.jar .
	cd ..;
	if [[ -z $1 ]]; then
		rm -r -f temp
	fi
	echo "done."
}

function dl(){
	merge $defaultDebugFileName
	cd $ROOT
	if [[ -f $defaultDebugFileName.jar ]]; then
		`kotlin $defaultDebugFileName.jar`
		rm $defaultDebugFileName.jar
	else
		echo "debug file not found"
	fi
	echo "debug complete"
}

function bl(){
	name=$defaultBuildFileName
	if [[ -n $1 ]]; then 
		name=$1
	fi
	merge $name
}

function merge(){
	
	rm -r -f temp
	lib-build
	build
	cd $ROOT
	mkdir -p temp
	cd temp
	`jar xf $ROOT/Libraries/out/libs.jar`
	`jar xf $ROOT/$defaultBuildFileName.jar`
	echo listing
	rm $ROOT/$defaultBuildFileName.jar
	`jar cmf META-INF/MANIFEST.MF ../$1.jar .`
	cd $ROOT
	rm -r -f temp
}

if [[ $1 = r ]] || [[ $1 = d ]]; then
	run $2
elif [[ $1 = b ]]; then
	build
elif [[ $1 = bl ]]; then
	bl $2
elif [[ $1 = rl ]] || [[ $1 = dl ]]; then
	dl
else echo  invalid params
fi

echo "Tasks Complete"

