# Nó do pulmão. Controla toda a mecânica de spawning de carcinógenos, movimento
# da Celinha (jogador) e captura por colisão.
extends Node2D

# Exporta cena do carcinógeno como PackedScene para que ela possa ser instanciada
# inúumeras vezes no spawning
export (PackedScene) var badMolecule
var velocity = Vector2.ZERO 
var badMoleculeCounter = 0 
var rng = RandomNumberGenerator.new() # Cria gerador de números aleatórios

# Randomiza a semente do gerador assim que o nó carrega
func _ready():
	rng.randomize()

# Controla os movimentos do jogador e suas colisões. É utilizada a função built-in
# _physics_process porque esu intervalo de loop é constante, o que evita erros 
# em cálculos de movimento.
func _physics_process(delta):
	# Variável booleana checa se Celinha está se movendo.
	var moving = false
	# Bloco para definir velocidade do jogador quando tanto uma seta 
	# quanto o espaço são pressionados.
	if Input.is_action_pressed("space"):
		if Input.is_action_pressed("ui_up"):
			moving = true
			velocity = Vector2(0, -4)
		if Input.is_action_pressed("ui_down"):
			velocity = Vector2(0, 4)
			moving = true
		if Input.is_action_pressed("ui_left"):
			velocity = Vector2(-4, 0)
			moving = true
		if Input.is_action_pressed("ui_right"):
			velocity = Vector2(4, 0)
			moving = true
	# Bloco para definir velocidade do jogador quando apenas uma seta é pressionada
	else:
		if Input.is_action_pressed("ui_up"):
			moving = true
			velocity = Vector2(0, -1.5)
		if Input.is_action_pressed("ui_down"):
			velocity = Vector2(0, 1.5)
			moving = true
		if Input.is_action_pressed("ui_left"):
			velocity = Vector2(-1.5, 0)
			moving = true
		if Input.is_action_pressed("ui_right"):
			velocity = Vector2(1.5, 0)
			moving = true
	# Inicia animação se Celinha estiver se movimentando
	if moving:
		$CeliaCell/CeliaCellAnimation.play()
	# Para animação quando Celinha parar
	else:
		$CeliaCell/CeliaCellAnimation.stop()
		velocity = Vector2.ZERO
	# Movimenta Celinha segundo a velocidade e salva as informações de uma possível colisão em uma variável
	var collision = $CeliaCell.move_and_collide(velocity)
	# Checa se houve uma colisão contra algum objeto exceto o pulmão. Se sim, deleta o objeto 
	# colidido (carcinógeno) da árvore.
	if collision and collision.collider != $LungsRigidBody:
		instance_from_id(collision.collider_id).queue_free()
		$Score.change_score(1) # Aumenta um ponto
		
# Função para criar carcinógenos toda vez que o timer de um segundo se completar
func _on_SpawnTimer_timeout():
	badMoleculeCounter += 1 # Conta mais um carcinógeno
	var badMoleculeScene = badMolecule.instance() # Cria o carcinógeno
	var locationPoint = rng.randi_range(1, 8) # Sorteia um número entre 1 e 8
	# O bloco abaixo escolhe uma posição de onde o carcinógeno vai surgir segundo
	# o locationPoint. Os nós PositionX para encontrar os pixels de posição. 
	# Já a velocidade indica também a direção na qual o carcinógeno será criado.
	if locationPoint == 1:
		badMoleculeScene.position = Vector2(600, 200)
		badMoleculeScene.velocity = Vector2(-50, 100)
	elif locationPoint == 2:
		badMoleculeScene.position = Vector2(337, 385)
		badMoleculeScene.velocity = Vector2(-50, -100)
	elif locationPoint == 3:
		badMoleculeScene.position = Vector2(436, 382)
		badMoleculeScene.velocity = Vector2(100, -100)
	elif locationPoint == 4:
		badMoleculeScene.position = Vector2(226, 144)
		badMoleculeScene.velocity = Vector2(100, 100)
	elif locationPoint == 5:
		badMoleculeScene.position = Vector2(140, 306)
		badMoleculeScene.velocity = Vector2(50, -50)
	elif locationPoint == 6:
		badMoleculeScene.position = Vector2(226, 144)
		badMoleculeScene.velocity = Vector2(100, 100)
	elif locationPoint == 7:
		badMoleculeScene.position = Vector2(358, 229)
		badMoleculeScene.velocity = Vector2(-100, 100)
	elif locationPoint == 8:
		badMoleculeScene.position = Vector2(652, 392)
		badMoleculeScene.velocity = Vector2(-100, -100)
	add_child(badMoleculeScene) # Adiciona o carcinógeno à árvore, fazendo-o aparecer na tela
	# Se trinta carcinógenos forem criados, parar o timer, o que impede que 
	# novos carcinógenos sejam criados
	if badMoleculeCounter >= 30:
		$SpawnTimer.stop()

# Se o botão voltar for pressionado, mudar a cena para a tela principal
func _on_ReturnButton_pressed():
	get_tree().change_scene("res://Main.tscn")
