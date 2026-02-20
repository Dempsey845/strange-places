class_name Items extends Node

enum ItemName {
	CoffeeBeans,
	TwentyDollarBill,
	FiftyDollarBill,
	Battery
}

static var ItemIcons = {
	ItemName.CoffeeBeans: "res://Assets/ItemIcons/coffee_beans.png",
	ItemName.TwentyDollarBill: "res://Assets/ItemIcons/20_note.png",
	ItemName.FiftyDollarBill: "res://Assets/ItemIcons/50_note.png",
	ItemName.Battery: "res://Assets/ItemIcons/battery.png"
}
