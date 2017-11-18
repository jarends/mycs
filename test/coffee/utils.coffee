expect = require('chai').expect
_      = require '../../js/utils'




describe "utils", () ->

    dom     = nodeType: 1
    domText = nodeType: 3

    types =
        isArray:        [['[]']]
        isBool:         [false, true]
        isNumber:       [0, 1]
        isString:       ['a']
        isObject:       [{}, dom, domText]
        isFunc:         [() -> null]
        isNot:          [null, undefined]
        isSimple:       [0, 1, true, false, 'a']
        isDom:          [dom]
        isDomText:      [domText]
        isSimpleOrNull: [0, 1, true, false, 'a', null]

    expectTrue = (type, value) ->
        it "should return true,  if value = #{value}", () -> expect(_[type](value)).to.equal true

    expectFalse = (type, value) ->
        it "should return false, if value = #{value}", () -> expect(_[type](value)).to.equal false

    for type, values of types

        describe ".#{type} value", () ->
            values = types[type]
            expectTrue type, v for v in values

            for n, a of types
                if n != type
                    (expectFalse type, v if values.indexOf(v) == -1) for v in a




    describe '.toCamelCase value', () ->
        it "should return toCamelCase, if value = to-camel-case", () ->
            expect(_.toCamelCase 'to-camel-case').to.equal 'toCamelCase'

        it "should return toCamelCase, if value = to_camel_case", () ->
            expect(_.toCamelCase 'to_camel_case').to.equal 'toCamelCase'

        it "should return toCamelCase, if value = to-camel_case", () ->
            expect(_.toCamelCase 'to-camel_case').to.equal 'toCamelCase'


    describe '.toKebabCase value', () ->
        it "should return to-kebab-case, if value = toKebabCase", () ->
            expect(_.toKebabCase 'toKebabCase').to.equal 'to-kebab-case'

        it "should return to-kebab-case, if value = to_kebab_case", () ->
            expect(_.toKebabCase 'to_kebab_case').to.equal 'to-kebab-case'

        it "should return to-kebab-case, if value = to_kebab-Case", () ->
            expect(_.toKebabCase 'to_kebab-Case').to.equal 'to-kebab-case'


    describe '.normalizeEvent value', () ->
        it "should return mousemove, if value = onMousemove", () ->
            expect(_.normalizeEvent 'onMousemove').to.equal 'mousemove'

        it "should return mouse-move, if value = onMouseMove", () ->
            expect(_.normalizeEvent 'onMouseMove').to.equal 'mouse-move'

        it "should return DOMContentLoaded, if value = $onDOMContentLoaded", () ->
            expect(_.normalizeEvent '$onDOMContentLoaded').to.equal 'DOMContentLoaded'




    describe '.deepExtend', () ->
        it "should deep extend an complex object", () ->
            target =
                a: 'target.a'
                b: 'target.b'
                c:
                    a: 'target.c.a'
                    b: 'target.c.b'
                    c: [cc0: 'target.c.c']


            source =
                b: 'source.b'
                c:
                    b: 'source.c.b'
                    c: [cc0: 'source.c.c']

            _.deepExtend(target, source)

            expect(target.a).  to.equal target.a
            expect(target.b).  to.equal source.b
            expect(target.c).  to.equal target.c
            expect(target.c.a).to.equal target.c.a
            expect(target.c.b).to.equal source.c.b
            expect(target.c.c).to.equal source.c.c




    describe '.saveDeepExtend', () ->
        it "should savely deep extend an complex object", () ->
            target     =
                a:   'target.a'
                b:   'target.b'
                c:
                    a: 'target.c.a'
                    b: 'target.c.b'
                    c: [cc0: 'target.c.c']

            bad        = {}
            source     =
                bad: bad
                b:   'source.b'
                c:
                    b: 'source.c.b'
                    c: [cc0: 'source.c.c']

            bad.ref    = source
            bad.circle = bad
            bad.a      = {}
            bad.b      = a:bad.a
            bad.a.b    = bad.b

            _.saveDeepExtend(target, source)

            expect(target.a).         to.equal target.a
            expect(target.b).         to.equal source.b
            expect(target.c).         to.equal target.c
            expect(target.c.a).       to.equal target.c.a
            expect(target.c.b).       to.equal source.c.b
            expect(target.c.c).       to.equal source.c.c
            expect(target.bad.ref).   to.equal target
            expect(target.bad.circle).to.equal target.bad
            expect(target.bad.a.b).   to.equal target.bad.b
            expect(target.bad.b.a).   to.equal target.bad.a


