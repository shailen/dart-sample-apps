file = '/usr/share/dict/words'
map = {}


if __name__ == "__main__":
    words = open(file).readlines()
    words = [word.strip() for word in words if word[0].islower()]
    for word in words:
        sortedWord = ''.join(sorted(list(word)))
        if sortedWord not in map:
            map[sortedWord] = [word]
        else:
            map[sortedWord].append(word)

    for key in map:
      if len(map[key]) > 6:
        print map[key]

