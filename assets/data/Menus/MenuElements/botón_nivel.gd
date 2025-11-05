extends Control

var save_data = JSON.new()

var tiempo_str: String
var desbloqueado: bool = true
@export_file("*.tscn") var nivel: String
var nombre_nivel: String
@export var num_nivel: int
var monedas: int
var vacas: int
var vacas_por_conseguir: int
var puntaje: int
func _ready() -> void :
    save_data = ResourceLoader.load("user://save_data.json")
    if not num_nivel > 4:
        tiempo_str = save_data.data.niveles[num_nivel - 1].tiempo_str
        desbloqueado = save_data.data.niveles[num_nivel - 1].desbloqueado
        nombre_nivel = save_data.data.niveles[num_nivel - 1].nombre
        monedas = save_data.data.niveles[num_nivel - 1].monedas
        vacas = save_data.data.niveles[num_nivel - 1].vacas
        vacas_por_conseguir = save_data.data.niveles[num_nivel - 1].vacas_por_conseguir
        puntaje = save_data.data.niveles[num_nivel - 1].puntos
    add_to_group("botones")
    set("disabled", not desbloqueado)
