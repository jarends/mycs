isArray        = Array.isArray
isBool         = (value) -> typeof value == 'boolean'
isNumber       = (value) -> typeof value == 'number'
isString       = (value) -> typeof value == 'string'
isObject       = (value) -> typeof value == 'object' and not isArray(value) and not isNot(value)
isFunc         = (value) -> typeof value == 'function'
isNot          = (value) -> value == null or value == undefined
isDom          = (value) -> not isNot(value) and value.nodeType == 1
isDomText      = (value) -> not isNot(value) and value.nodeType == 3
isSimple       = (value) -> (t = typeof value) == 'string' or t == 'number' or t == 'boolean'
isSimpleOrNull = (value) -> value == null or (t = typeof value) == 'string' or t == 'number' or t == 'boolean'
getOrCall      = (value) -> if isFunc(value) then value() else value




toCamelCase = (value) ->
    value.replace /(-|_)[a-z]/g, (value) ->
        value.charAt(1).toUpperCase()




toKebabCase = (value) ->
    value = value.replace /.[A-Z]/g, (n) ->
        n0 = n[0]
        if n0 != '_' and n0 != '-'
            n0 + '-' + n[1].toLowerCase()
        else
            n0 + n[1].toLowerCase()
    value.replace /_/g, '-'




normalizeEvent = (type) ->
    if type[0] == '$'
        type = type.slice 3
    else
        type = type.slice 2
        type = type.charAt(0).toLowerCase() + toKebabCase type.slice 1
    type




deepExtend = (target, source) ->
    if source and isObject source
        for key, value of source
            if isObject(value) and not isArray(source)
                targetValue = target[key]
                if not isObject targetValue
                    targetValue = {}
                if targetValue != value
                    target[key] = deepExtend targetValue, value
            else
                target[key] = value
    target




saveDeepExtend = (target, source, smap) ->
    smap = smap or new Map()
    de   = (target, source) ->
        smap.set source, target
        if source and isObject source
            for key, value of source
                if isObject(value) and not isArray(source)
                    has = smap.get value
                    if has
                        target[key] = has
                    else
                        targetValue = target[key]
                        if not isObject targetValue
                            targetValue = {}
                        if targetValue != value
                            target[key] = de targetValue, value
                else
                    target[key] = value
        target
    de target, source




deepMerge = (target, sources...) ->
    for source in sources
        deepExtend target, source
    target




deepMergeSave = (target, sources...) ->
    smap =  new Map()
    for source in sources
        deepMergeSave target, source, smap
    target




size = (view, width, height) ->
    view.style.width  = width  + 'px'
    view.style.height = height + 'px'




position = (view, x, y) ->
    view.style.left = x + 'px';
    view.style.top  = y + 'px';




transform = (view, x, y, angle, scale) ->
    setTransform(view.style, "translate(#{x}px,#{y}px) rotate(#{angle}deg) scale(#{scale})");




translate = (view, x, y) ->
    setTransform(view.style, "translate(#{x}px,#{y}px)");




rotate = (view, angle) ->
    setTransform(view.style, "rotate(#{angle}deg)");




scale = (view, scale) ->
    setTransform(view.style, "scale(#{scale})");




setTransform = (style, transform) ->
    style.webkitTransform = transform;
    style.transform       = transform;




cloneCanvas = (canvas) ->
    newCanvas        = document.createElement 'canvas'
    context          = newCanvas.getContext '2d'
    newCanvas.width  = canvas.width
    newCanvas.height = canvas.height

    context.drawImage canvas, 0, 0
    return newCanvas;




module.exports =
    isArray:        isArray
    isBool:         isBool
    isNumber:       isNumber
    isString:       isString
    isObject:       isObject
    isFunc:         isFunc
    isDom:          isDom
    isDomText:      isDomText
    isNot:          isNot
    isSimple:       isSimple
    isSimpleOrNull: isSimpleOrNull
    getOrCall:      getOrCall
    toCamelCase:    toCamelCase
    toKebabCase:    toKebabCase
    normalizeEvent: normalizeEvent
    deepExtend:     deepExtend
    saveDeepExtend: saveDeepExtend
    deepMerge:      deepMerge
    Rect:           require './rect'
    getBounds:      require './get-bounds'
    size:           size
    position:       position
    transform:      transform
    translate:      translate
    rotate:         rotate
    scale:          scale
    setTramsform:   setTransform
    cloneCanvas:    cloneCanvas