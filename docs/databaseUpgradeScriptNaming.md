# Database Upgrade Script Naming

This document describes how to name database upgrade scripts so that they can be merged without causing
collisions.

# File structure in the database project

	grails-app
		migrations
			9.9.x
				01-foo.groovy
				02-bar.groovy
			9.9.3.y
				01-hello.groovy
				02-world.groovy
			changelog.groovy

Directories are made for main stable and development branches, NOT for feature branches.

# changelog.groovy structure

	databaseChangeLog = {
		include(file: '9.9.x/01-foo.groovy')
		include(file: '9.9.x/02-bar.groovy')
		include(file: '9.9.3.y/01-hello.groovy')
		include(file: '9.9.3.y/02-world.groovy')
		include(file: 'AlwaysLast-NewObjectId.groovy')
	}

# Individual scripts

## 9.9.x example

	databaseChangeLog = {
		clid = '9-9-01'

		changeSet(id: "${clid}.1", author: "ken") {
			// foo
		}
	}

## 9.9.3.y example


	databaseChangeLog = {
		clid = '9-9-3-01'

		changeSet(id: "${clid}.1", author: "ken") {
			// hello
		}
	}

# Merging

## Merging from stable branch to developer branch

1. Files and directories stay as they are, telling us where the script was first introduced.
2. Changelog id's are immutable and so are the changesets.

## New major database version

1. All branches are merged in.
2. Follow existing procedure (make new schema.groovy)
3. Remove existing scripts and their directories
4. Make a new branch directory and a new changelog.groovy