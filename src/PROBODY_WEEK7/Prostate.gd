# Nó da próstata. Controla atuação da Celinha, carcinógenos e células cancerosas.
extends Node2D

# Exporta cena do carcinógeno e da célula cancerosa como PackedScene
export (PackedScene) var badMolecule

# Variáveis básicas para controle dos carcinógenos
var velocity = Vector2.ZERO 
var badMoleculeCounter = 0 
var rng = RandomNumberGenerator.new() # Cria gerador de números aleatórios

# Randomiza a semente do gerador assim que o nó carrega
func _ready():
	# Troca cursor pelo símbolo de metabolismo
	Input.set_custom_mouse_cursor(Global.organMouse, 0, Global.mouseHotspot)
	rng.randomize()
	if Global.soundIsActive:
		Global.play_organ_music() # Começa música a ser tocada nos órgãos

# Movimenta Celinha conforme função move_cell em script próprio e impede que ela saia do pulmão.
func _physics_process(_delta):
	$Celinha.move_cell()
	if Global.organScore == 10:
		Global.tree = get_tree().change_scene("res://Main.tscn")
		Global.organScore = 0
# Função para criar carcinógenos toda vez que o timer se completar
func _on_SpawnTimer_timeout():
	badMoleculeCounter += 1
	var badMoleculeScene = badMolecule.instance() # Cria o carcinógeno
	var locationPoint = rng.randi_range(1, 4) # Sorteia ponto de spawning
	badMoleculeScene.organ = "ProstateStaticBody2D"
	# Escolhe um dentre oito pontos para gerar carcinógenos. Também sorteia a velocidade.
	match locationPoint:
		1:
			badMoleculeScene.position = $ProstateStaticBody2D/ProstatePosition1.position
			badMoleculeScene.velocity = Vector2(rand_range(-100, -20), rand_range(-160, -70))
		2:
			badMoleculeScene.position = $ProstateStaticBody2D/ProstatePosition2.position
			badMoleculeScene.velocity = Vector2(rand_range(-100, -20), rand_range(-160, -70))
		3:
			badMoleculeScene.position = $ProstateStaticBody2D/ProstatePosition3.position
			badMoleculeScene.velocity = Vector2(rand_range(20, 100), rand_range(-160, -70))
		4:
			badMoleculeScene.position = $ProstateStaticBody2D/ProstatePosition4.position
			badMoleculeScene.velocity = Vector2(rand_range(160, 70), rand_range(160, 70))
		_:
			badMoleculeScene.position = $ProstateStaticBody2D/ProstatePosition4.position
			badMoleculeScene.velocity = Vector2(rand_range(-100, -20), rand_range(-160, -70))
	add_child(badMoleculeScene) # Adiciona o carcinógeno à árvore, fazendo-o aparecer na tela
	# Se 10 carcinógenos forem criados, para o timer, o que impede que 
	# novos carcinógenos sejam criados
	if badMoleculeCounter >= 10:
		$SpawnTimer.stop()

# Se o botão voltar for pressionado, mudar a cena para a tela principal
func _on_ReturnButton_pressed():
	Global.stop_organ_music() # Para a música
	Global.tree = get_tree().change_scene("res://Main.tscn")
	
