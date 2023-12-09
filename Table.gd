extends Control
class_name Table


@onready var TableRow = preload("res://table_row.tscn")
@onready var TableCell = preload("res://table_cell.tscn")
@onready var TableHeaderCell = preload("res://table_header_cell.tscn")


@export var data: DataFrame

var sorted_by: String
var sort_dir = false


func _ready():
	pass

func _process(delta):
	
	var mPos = get_local_mouse_position()
	if Rect2(Vector2.ZERO, size).has_point(mPos):
		
		var col_size = size.x / len(data.columns)
		var row_size = size.y / (data.Size() + 1)
		var cell_size = Vector2(col_size, row_size)
		
		var mSnapped = (mPos - cell_size / 2.0).snapped(cell_size)
		
		$ColumnHighlight.position.x = mSnapped.x
		$RowHighlight.position.y = mSnapped.y


func Render():
	for n in $Rows.get_children():
		n.queue_free()
	
	if data:
		var row_count = data.Size()
		
		var cols_row = TableRow.instantiate()
		for col in data.columns:
			var cell = TableHeaderCell.instantiate()
			cell.text = col
			cols_row.add_child(cell)
			cell.pressed.connect(_on_column_header_pressed.bind(col))
		$Rows.add_child(cols_row)
		
		for r in range(row_count):
			var row = TableRow.instantiate()
			$Rows.add_child(row)
			
			for value in data.GetRow(r):
				var cell = TableCell.instantiate()
				cell.text = str(value)
				row.add_child(cell)
		
		$RowHighlight.size.y = size.y / (row_count + 1)
		$ColumnHighlight.size.x = size.x / (len(data.columns))


func _on_column_header_pressed(col):
	print("Column clicked: ", col)
	sorted_by = col
	
	data.SortBy(col, sort_dir)
	sort_dir = !sort_dir
	Render()
