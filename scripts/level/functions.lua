local level = {}
local dir = 'levels/'

function generateLine(character, widthLine)
  local line = character
  for i=1, widthLine - 1 do
    line = line .. character
  end

  return line
end

function import(titleFile)
  -- Ouvrir le fichier en mode lecture
  local file = io.open(dir .. titleFile .. ".txt", "r")

  -- Vérifier si le fichier a été ouvert avec succès
  if not file then
    print("Erreur : impossible d'ouvrir le fichier.")
    os.exit(1)
  end

  -- Créer un tableau vide pour stocker les valeurs
  local map = {}

  -- Itérer sur les lignes du fichier
  for line in file:lines() do
      -- Ajouter chaque valeur au tableau
      table.insert(map, line)
  end

  -- Fermer le fichier
  file:close()

  return map
end

function export(level, titleFile)
  -- Convertit la table en chaîne de caractères en utilisant le generateLine
  --local mylevel = table.concat(level, "\n")

  -- Ouvre un fichier en mode écriture
  local file = io.open(dir .. titleFile .. ".txt", "w")

  -- Vérification si le fichier est ouvert
  if file then
    -- Écriture des données de la table dans le fichier
    for i = 1, #level do
      for j = 1, #level[i] do
        file:write(level[i][j])
        -- Ajout d'un séparateur entre les éléments
        if j == #level[i] then
          file:write("\n") -- Nouvelle ligne à la fin de chaque ligne de la table
        end
      end
    end

    print("La table a bien été exportée")
    -- Ferme le fichier
    file:close()
  else
    print("Impossible de créer le fichier")
  end
end

function createLevel(level, nbLine, nbColumn, value, sideValue)
  for l=1, nbLine do
    level[l] = {}
    for c=1, nbColumn do
      if l == 1 or l == nbLine or c == 1 or c == nbColumn then
        level[l][c] = sideValue
      else
        level[l][c] = value
      end
    end
  end 
end

function modifyLevel(levelTitle)
  local readFile = io.open(dir .. levelTitle .. ".txt", "r")

  if not readFile then
    print("Erreur : impossible d'ouvrir le fichier.")
    os.exit(1)
  end

  local level = {}

  for line in readFile:lines() do
    table.insert(level, line)
  end

  readFile:close()

  local writeFile = io.open(dir .. levelTitle .. ".txt", "w")

  -- print(#level, string.sub(level[1],0,1))

  for l=1, #level do
    for c=1, #level[1] do
      if c == 1 and l ~= 1 and l ~= #level then
        level[l] = string.gsub(level[l],'1','4', 1)
      end
    end
    writeFile:write(level[l], '\n')
  end 
  -- local mylevel = table.concat(level, "\n")
  writeFile:close()
end


modifyLevel('level0test')