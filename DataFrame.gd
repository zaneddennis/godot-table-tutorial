extends Resource
class_name DataFrame


@export var data: Array
@export var columns: PackedStringArray


# custom constructor
static func New(d: Array, c: PackedStringArray) -> DataFrame:
	var df = DataFrame.new()
	
	df.data = d
	if c:
		df.columns = c
	
	return df


# adders
func AddColumn(d: Array, col_name: String):
	assert(len(d) == Size())
	
	for i in range(Size()):
		data[i].append(d[i])
	
	columns.append(col_name)

func AddRow():
	pass


# getters
func GetColumn(col: String):
	assert(col in columns)
	
	var ix = columns.find(col)
	var result = []
	
	for row in data:
		result.append(row[ix])
	
	return result

func GetRow(i):
	return data[i]


# sorting
func _sort_by(left, right, i, desc):
	var result: bool
	if left[i] < right[i]:
		result = true
	else:
		result = false
	
	if desc:
		result = !result
	
	return result

func SortBy(col: String, desc=false):
	assert(col in columns)
	var ix = columns.find(col)
	data.sort_custom(_sort_by.bind(ix, desc))


static func EvalColumns(c1: Array, operand: String, c2: Array, convert_to_float: bool = false):
	assert(len(c1) == len(c2))
	
	var expression = Expression.new()
	if convert_to_float:
		expression.parse("float(a) %s float(b)" % operand, ["a", "b"])
	else:
		expression.parse("a %s b" % operand, ["a", "b"])
	
	var result = []
	for i in range(len(c1)):
		result.append(
			expression.execute([c1[i], c2[i]])
		)
	
	return result


# attributes
func Size():
	return len(data)

func _to_string():
	if len(data) == 0:
		return "<empty DataFrame>"
	
	var result = "|".join(columns) + "\n----------\n"  # TODO: compute length of this more elegantly
	
	for row in data:
		result += "|".join(row) + "\n"
	
	return result
