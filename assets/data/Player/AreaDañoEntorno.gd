extends Area2D

func _on_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
    if body is TileMapLayer:
        var tiledata = body.get_cell_tile_data(body.local_to_map(global_position))
        if tiledata and tiledata.get_custom_data("Daño") == true:
            $"..".take_damage(11)
