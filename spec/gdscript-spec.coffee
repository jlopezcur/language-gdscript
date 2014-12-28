describe "GDScript grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-gdscript")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.gdscript")

  it "parses the grammar", ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe "source.gdscript"

  it "tokenizes multi-line strings", ->
    tokens = grammar.tokenizeLines('"1\\\n2"')

    # Line 0
    expect(tokens[0][0].value).toBe '"'
    expect(tokens[0][0].scopes).toEqual ['source.gdscript', 'string.quoted.double.single-line.gdscript', 'punctuation.definition.string.begin.gdscript']

    expect(tokens[0][1].value).toBe '1'
    expect(tokens[0][1].scopes).toEqual ['source.gdscript', 'string.quoted.double.single-line.gdscript']

    expect(tokens[0][2].value).toBe '\\'
    expect(tokens[0][2].scopes).toEqual ['source.gdscript', 'string.quoted.double.single-line.gdscript', 'constant.character.escape.newline.gdscript']

    expect(tokens[0][3]).not.toBeDefined()

    # Line 1
    expect(tokens[1][0].value).toBe '2'
    expect(tokens[1][0].scopes).toEqual ['source.gdscript', 'string.quoted.double.single-line.gdscript']

    expect(tokens[1][1].value).toBe '"'
    expect(tokens[1][1].scopes).toEqual ['source.gdscript', 'string.quoted.double.single-line.gdscript', 'punctuation.definition.string.end.gdscript']

    expect(tokens[1][2]).not.toBeDefined()

  it "terminates a single-quoted raw string containing opening parenthesis at closing quote", ->
    tokens = grammar.tokenizeLines("r'%d(' #foo")

    expect(tokens[0][0].value).toBe 'r'
    expect(tokens[0][0].scopes).toEqual ['source.gdscript', 'string.quoted.single.single-line.raw-regex.gdscript', 'storage.type.string.gdscript']
    expect(tokens[0][1].value).toBe "'"
    expect(tokens[0][1].scopes).toEqual ['source.gdscript', 'string.quoted.single.single-line.raw-regex.gdscript', 'punctuation.definition.string.begin.gdscript']
    expect(tokens[0][2].value).toBe '%d'
    expect(tokens[0][2].scopes).toEqual ['source.gdscript', 'string.quoted.single.single-line.raw-regex.gdscript', 'constant.other.placeholder.gdscript']
    expect(tokens[0][3].value).toBe '('
    expect(tokens[0][3].scopes).toEqual ['source.gdscript', 'string.quoted.single.single-line.raw-regex.gdscript', 'meta.group.regexp', 'punctuation.definition.group.regexp']
    expect(tokens[0][4].value).toBe "'"
    expect(tokens[0][4].scopes).toEqual ['source.gdscript', 'string.quoted.single.single-line.raw-regex.gdscript', 'punctuation.definition.string.end.gdscript']
    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.gdscript']
    expect(tokens[0][6].value).toBe '#'
    expect(tokens[0][6].scopes).toEqual ['source.gdscript', 'comment.line.number-sign.gdscript', 'punctuation.definition.comment.gdscript']
    expect(tokens[0][7].value).toBe 'foo'
    expect(tokens[0][7].scopes).toEqual ['source.gdscript', 'comment.line.number-sign.gdscript']

  it "terminates a single-quoted raw string containing opening bracket at closing quote", ->
    tokens = grammar.tokenizeLines("r'%d[' #foo")

    expect(tokens[0][0].value).toBe 'r'
    expect(tokens[0][0].scopes).toEqual ['source.gdscript', 'string.quoted.single.single-line.raw-regex.gdscript', 'storage.type.string.gdscript']
    expect(tokens[0][1].value).toBe "'"
    expect(tokens[0][1].scopes).toEqual ['source.gdscript', 'string.quoted.single.single-line.raw-regex.gdscript', 'punctuation.definition.string.begin.gdscript']
    expect(tokens[0][2].value).toBe '%d'
    expect(tokens[0][2].scopes).toEqual ['source.gdscript', 'string.quoted.single.single-line.raw-regex.gdscript', 'constant.other.placeholder.gdscript']
    expect(tokens[0][3].value).toBe '['
    expect(tokens[0][3].scopes).toEqual ['source.gdscript', 'string.quoted.single.single-line.raw-regex.gdscript', 'constant.other.character-class.set.regexp', 'punctuation.definition.character-class.regexp']
    expect(tokens[0][4].value).toBe "'"
    expect(tokens[0][4].scopes).toEqual ['source.gdscript', 'string.quoted.single.single-line.raw-regex.gdscript', 'punctuation.definition.string.end.gdscript']
    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.gdscript']
    expect(tokens[0][6].value).toBe '#'
    expect(tokens[0][6].scopes).toEqual ['source.gdscript', 'comment.line.number-sign.gdscript', 'punctuation.definition.comment.gdscript']
    expect(tokens[0][7].value).toBe 'foo'
    expect(tokens[0][7].scopes).toEqual ['source.gdscript', 'comment.line.number-sign.gdscript']

  it "terminates a double-quoted raw string containing opening parenthesis at closing quote", ->
    tokens = grammar.tokenizeLines('r"%d(" #foo')

    expect(tokens[0][0].value).toBe 'r'
    expect(tokens[0][0].scopes).toEqual ['source.gdscript', 'string.quoted.double.single-line.raw-regex.gdscript', 'storage.type.string.gdscript']
    expect(tokens[0][1].value).toBe '"'
    expect(tokens[0][1].scopes).toEqual ['source.gdscript', 'string.quoted.double.single-line.raw-regex.gdscript', 'punctuation.definition.string.begin.gdscript']
    expect(tokens[0][2].value).toBe '%d'
    expect(tokens[0][2].scopes).toEqual ['source.gdscript', 'string.quoted.double.single-line.raw-regex.gdscript', 'constant.other.placeholder.gdscript']
    expect(tokens[0][3].value).toBe '('
    expect(tokens[0][3].scopes).toEqual ['source.gdscript', 'string.quoted.double.single-line.raw-regex.gdscript', 'meta.group.regexp', 'punctuation.definition.group.regexp']
    expect(tokens[0][4].value).toBe '"'
    expect(tokens[0][4].scopes).toEqual ['source.gdscript', 'string.quoted.double.single-line.raw-regex.gdscript', 'punctuation.definition.string.end.gdscript']
    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.gdscript']
    expect(tokens[0][6].value).toBe '#'
    expect(tokens[0][6].scopes).toEqual ['source.gdscript', 'comment.line.number-sign.gdscript', 'punctuation.definition.comment.gdscript']
    expect(tokens[0][7].value).toBe 'foo'
    expect(tokens[0][7].scopes).toEqual ['source.gdscript', 'comment.line.number-sign.gdscript']

  it "terminates a double-quoted raw string containing opening bracket at closing quote", ->
    tokens = grammar.tokenizeLines('r"%d[" #foo')

    expect(tokens[0][0].value).toBe 'r'
    expect(tokens[0][0].scopes).toEqual ['source.gdscript', 'string.quoted.double.single-line.raw-regex.gdscript', 'storage.type.string.gdscript']
    expect(tokens[0][1].value).toBe '"'
    expect(tokens[0][1].scopes).toEqual ['source.gdscript', 'string.quoted.double.single-line.raw-regex.gdscript', 'punctuation.definition.string.begin.gdscript']
    expect(tokens[0][2].value).toBe '%d'
    expect(tokens[0][2].scopes).toEqual ['source.gdscript', 'string.quoted.double.single-line.raw-regex.gdscript', 'constant.other.placeholder.gdscript']
    expect(tokens[0][3].value).toBe '['
    expect(tokens[0][3].scopes).toEqual ['source.gdscript', 'string.quoted.double.single-line.raw-regex.gdscript', 'constant.other.character-class.set.regexp', 'punctuation.definition.character-class.regexp']
    expect(tokens[0][4].value).toBe '"'
    expect(tokens[0][4].scopes).toEqual ['source.gdscript', 'string.quoted.double.single-line.raw-regex.gdscript', 'punctuation.definition.string.end.gdscript']
    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.gdscript']
    expect(tokens[0][6].value).toBe '#'
    expect(tokens[0][6].scopes).toEqual ['source.gdscript', 'comment.line.number-sign.gdscript', 'punctuation.definition.comment.gdscript']
    expect(tokens[0][7].value).toBe 'foo'
    expect(tokens[0][7].scopes).toEqual ['source.gdscript', 'comment.line.number-sign.gdscript']

  it "terminates a unicode single-quoted raw string containing opening parenthesis at closing quote", ->
    tokens = grammar.tokenizeLines("ur'%d(' #foo")

    expect(tokens[0][0].value).toBe 'ur'
    expect(tokens[0][0].scopes).toEqual ['source.gdscript', 'string.quoted.single.single-line.unicode-raw-regex.gdscript', 'storage.type.string.gdscript']
    expect(tokens[0][1].value).toBe "'"
    expect(tokens[0][1].scopes).toEqual ['source.gdscript', 'string.quoted.single.single-line.unicode-raw-regex.gdscript', 'punctuation.definition.string.begin.gdscript']
    expect(tokens[0][2].value).toBe '%d'
    expect(tokens[0][2].scopes).toEqual ['source.gdscript', 'string.quoted.single.single-line.unicode-raw-regex.gdscript', 'constant.other.placeholder.gdscript']
    expect(tokens[0][3].value).toBe '('
    expect(tokens[0][3].scopes).toEqual ['source.gdscript', 'string.quoted.single.single-line.unicode-raw-regex.gdscript', 'meta.group.regexp', 'punctuation.definition.group.regexp']
    expect(tokens[0][4].value).toBe "'"
    expect(tokens[0][4].scopes).toEqual ['source.gdscript', 'string.quoted.single.single-line.unicode-raw-regex.gdscript', 'punctuation.definition.string.end.gdscript']
    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.gdscript']
    expect(tokens[0][6].value).toBe '#'
    expect(tokens[0][6].scopes).toEqual ['source.gdscript', 'comment.line.number-sign.gdscript', 'punctuation.definition.comment.gdscript']
    expect(tokens[0][7].value).toBe 'foo'
    expect(tokens[0][7].scopes).toEqual ['source.gdscript', 'comment.line.number-sign.gdscript']

  it "terminates a unicode single-quoted raw string containing opening bracket at closing quote", ->
    tokens = grammar.tokenizeLines("ur'%d[' #foo")

    expect(tokens[0][0].value).toBe 'ur'
    expect(tokens[0][0].scopes).toEqual ['source.gdscript', 'string.quoted.single.single-line.unicode-raw-regex.gdscript', 'storage.type.string.gdscript']
    expect(tokens[0][1].value).toBe "'"
    expect(tokens[0][1].scopes).toEqual ['source.gdscript', 'string.quoted.single.single-line.unicode-raw-regex.gdscript', 'punctuation.definition.string.begin.gdscript']
    expect(tokens[0][2].value).toBe '%d'
    expect(tokens[0][2].scopes).toEqual ['source.gdscript', 'string.quoted.single.single-line.unicode-raw-regex.gdscript', 'constant.other.placeholder.gdscript']
    expect(tokens[0][3].value).toBe '['
    expect(tokens[0][3].scopes).toEqual ['source.gdscript', 'string.quoted.single.single-line.unicode-raw-regex.gdscript', 'constant.other.character-class.set.regexp', 'punctuation.definition.character-class.regexp']
    expect(tokens[0][4].value).toBe "'"
    expect(tokens[0][4].scopes).toEqual ['source.gdscript', 'string.quoted.single.single-line.unicode-raw-regex.gdscript', 'punctuation.definition.string.end.gdscript']
    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.gdscript']
    expect(tokens[0][6].value).toBe '#'
    expect(tokens[0][6].scopes).toEqual ['source.gdscript', 'comment.line.number-sign.gdscript', 'punctuation.definition.comment.gdscript']
    expect(tokens[0][7].value).toBe 'foo'
    expect(tokens[0][7].scopes).toEqual ['source.gdscript', 'comment.line.number-sign.gdscript']

  it "terminates a unicode double-quoted raw string containing opening parenthesis at closing quote", ->
    tokens = grammar.tokenizeLines('ur"%d(" #foo')

    expect(tokens[0][0].value).toBe 'ur'
    expect(tokens[0][0].scopes).toEqual ['source.gdscript', 'string.quoted.double.single-line.unicode-raw-regex.gdscript', 'storage.type.string.gdscript']
    expect(tokens[0][1].value).toBe '"'
    expect(tokens[0][1].scopes).toEqual ['source.gdscript', 'string.quoted.double.single-line.unicode-raw-regex.gdscript', 'punctuation.definition.string.begin.gdscript']
    expect(tokens[0][2].value).toBe '%d'
    expect(tokens[0][2].scopes).toEqual ['source.gdscript', 'string.quoted.double.single-line.unicode-raw-regex.gdscript', 'constant.other.placeholder.gdscript']
    expect(tokens[0][3].value).toBe '('
    expect(tokens[0][3].scopes).toEqual ['source.gdscript', 'string.quoted.double.single-line.unicode-raw-regex.gdscript', 'meta.group.regexp', 'punctuation.definition.group.regexp']
    expect(tokens[0][4].value).toBe '"'
    expect(tokens[0][4].scopes).toEqual ['source.gdscript', 'string.quoted.double.single-line.unicode-raw-regex.gdscript', 'punctuation.definition.string.end.gdscript']
    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.gdscript']
    expect(tokens[0][6].value).toBe '#'
    expect(tokens[0][6].scopes).toEqual ['source.gdscript', 'comment.line.number-sign.gdscript', 'punctuation.definition.comment.gdscript']
    expect(tokens[0][7].value).toBe 'foo'
    expect(tokens[0][7].scopes).toEqual ['source.gdscript', 'comment.line.number-sign.gdscript']

  it "terminates a unicode double-quoted raw string containing opening bracket at closing quote", ->
    tokens = grammar.tokenizeLines('ur"%d[" #foo')

    expect(tokens[0][0].value).toBe 'ur'
    expect(tokens[0][0].scopes).toEqual ['source.gdscript', 'string.quoted.double.single-line.unicode-raw-regex.gdscript', 'storage.type.string.gdscript']
    expect(tokens[0][1].value).toBe '"'
    expect(tokens[0][1].scopes).toEqual ['source.gdscript', 'string.quoted.double.single-line.unicode-raw-regex.gdscript', 'punctuation.definition.string.begin.gdscript']
    expect(tokens[0][2].value).toBe '%d'
    expect(tokens[0][2].scopes).toEqual ['source.gdscript', 'string.quoted.double.single-line.unicode-raw-regex.gdscript', 'constant.other.placeholder.gdscript']
    expect(tokens[0][3].value).toBe '['
    expect(tokens[0][3].scopes).toEqual ['source.gdscript', 'string.quoted.double.single-line.unicode-raw-regex.gdscript', 'constant.other.character-class.set.regexp', 'punctuation.definition.character-class.regexp']
    expect(tokens[0][4].value).toBe '"'
    expect(tokens[0][4].scopes).toEqual ['source.gdscript', 'string.quoted.double.single-line.unicode-raw-regex.gdscript', 'punctuation.definition.string.end.gdscript']
    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.gdscript']
    expect(tokens[0][6].value).toBe '#'
    expect(tokens[0][6].scopes).toEqual ['source.gdscript', 'comment.line.number-sign.gdscript', 'punctuation.definition.comment.gdscript']
    expect(tokens[0][7].value).toBe 'foo'
    expect(tokens[0][7].scopes).toEqual ['source.gdscript', 'comment.line.number-sign.gdscript']
