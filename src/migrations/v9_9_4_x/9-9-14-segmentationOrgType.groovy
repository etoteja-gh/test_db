package v9_9_x

databaseChangeLog{
	clid = '9-9-14'
	changeSet(id: "${clid}.1", author: "Alexey") {
		sql("update AppParam set variable='segmentationOrgType' where variable='lowestHierarchyLevel'")
		sql("update AppParam set variable='applyOnlyWithinSegmentationOrgType' where variable='ApplyOnlyWithinLowestHierarchyLevel'")
	}
}
