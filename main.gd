extends Node


func _ready():
	var columns = ["Team", "Won", "Lost"]
	var data = [
		["NYC", 3, 1],
		["LOS", 2, 3],
		["PHI", 3, 2],
		["TEX", 4, 0],
		["DET", 0, 3],
		["DEN", 1, 3]
	]
	
	var df = DataFrame.New(data, columns)
	
	$Panel/Table.data = df
	
	var games_played = DataFrame.EvalColumns(
		df.GetColumn("Won"),
		"+",
		df.GetColumn("Lost")
	)
	df.AddColumn(games_played, "Played")
	
	var pct = DataFrame.EvalColumns(
		df.GetColumn("Won"),
		"/",
		df.GetColumn("Played"),
		true
	)
	df.AddColumn(pct, "Pct")
	
	df.SortBy("Pct", true)
	
	$Panel/Table.Render()
