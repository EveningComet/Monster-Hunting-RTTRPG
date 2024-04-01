## Works as the inbetween for a character and their job data.
class_name JobHolder
extends Node

## The job being kept track of.
@export var job_data: Job

## Get the job being stored.
func get_job_data() -> Job:
	return job_data
