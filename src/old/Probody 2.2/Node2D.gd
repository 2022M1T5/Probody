# Nó do pulmão. Controla atuação da Celinha, carcinógenos e células cancerosas.
extends Node2D

# Exporta cena do carcinógeno e da célula cancerosa como PackedScenes 
# para que elas possam ser instanciadas inúmeras vezes
export (PackedScene) var cancerCell
export (PackedScene) var badMolecule

# Variáveis básicas para controle dos carcinógenos
var velocity = Vector2.ZERO 
var badMoleculeCounter = 0 
var rng = RandomNumberGenerator.new() # Cria gerador de números aleatórios

# Randomiza a semente do gerador assim que o nó carrega
func _ready():
	rng.randomize()
	if Global.soundIsActive:
		Global.play_organ_music() # Começa música a ser tocada nos órgãos

# Movimenta Celinha conforme função move_cell em script próprio.
func _physics_process(_delta):
	$Celinha.move_cell()
	if Global.organScore == 10:
		Global.tree = get_tree().change_scene("res://Main.tscn")
		Global.organScore = 0
# Função para criar carcinógenos toda vez que o timer se completar
func _on_SpawnTimer_timeout():
	badMoleculeCounter += 1
	var badMoleculeScene = badMolecule.instance() # Cria o carcinógeno
	var locationPoint = rng.randi_range(1, 8) # Sorteia ponto de spawning
	badMoleculeScene.organ = "SkinRigidBody"
	# Escolhe um dentre oito pontos para gerar carcinógenos. Também sorteia a velocidade.
	if locationPoint == 1:
		badMoleculeScene.position = Vector2(210, 120)
		badMoleculeScene.velocity = Vector2(rand_range(-100, -20), rand_range(-160, -70))
	elif locationPoint == 2:
		badMoleculeScene.position = Vector2(460, 90)
		badMoleculeScene.velocity = Vector2(rand_range(-100, -20), rand_range(-160, -70))
	elif locationPoint == 3:
		badMoleculeScene.position = Vector2(710, 190)
		badMoleculeScene.velocity = Vector2(rand_range(20, 100), rand_range(-160, -70))
	elif locationPoint == 4:
		badMoleculeScene.position = Vector2(200, 240)
		badMoleculeScene.velocity = Vector2(rand_range(160, 70), rand_range(160, 70))
	elif locationPoint == 5:
		badMoleculeScene.position = Vector2(340, 490)
		badMoleculeScene.velocity = Vector2(rand_range(-100, -20), rand_range(-100, -20))
	elif locationPoint == 6:
		badMoleculeScene.position = Vector2(570, 530)
		badMoleculeScene.velocity = Vector2(rand_range(160, 70), rand_range(160, 70))
	elif locationPoint == 7:
		badMoleculeScene.position = Vector2(760, 410)
		badMoleculeScene.velocity = Vector2(rand_range(-160, -70), rand_range(160, 70))
	add_child(badMoleculeScene) # Adiciona o carcinógeno à árvore, fazendo-o aparecer na tela
	# Se cem carcinógenos forem criados, para o timer, o que impede que 
	# novos carcinógenos sejam criados
	if badMoleculeCounter >= 10:
		$SpawnTimer.stop()
# Se o botão voltar for pressionado, mudar a cena para a tela principal
func _on_ReturnButton_pressed():
	Global.stop_organ_music() # Para a música
	Global.tree = get_tree().change_scene("res://Main.tscn")
	
