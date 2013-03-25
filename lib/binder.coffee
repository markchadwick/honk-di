
class Binding
  matches: (proto) ->
    throw Error('Binding.matches not implemented')

  create: (defaultFactory) ->
    defaultFactory()

class ClassBinding extends Binding
  constructor: (@iface) ->
    super()
    if @iface.scope? then @inScope(@iface.scope)

  to: (impl) ->
    if @impl? then throw Error('Already bound')
    @impl = impl
    if impl.scope? then @scope = impl.scope.toUpperCase()
    this

  inScope: (scope) ->
    if @scope? and @scope isnt scope
      throw Error("Already scoped to #{@scope}")

    switch scope.toUpperCase()
      when 'SINGLETON' then @scope = 'SINGLETON'
      when 'INSTANCE' then # Just ignore
      else throw Error("Invalid scope, '#{scope}'")
    this

  matches: (cls) ->
    cls is @iface

class ConstantBinding extends Binding
  constructor: (@name) ->

  to: (@value) ->

  matches: (cls) ->
    cls is @name

  create: ->
    @value

class Binder
  constructor: ->
    @bindings = []
    @configure()

  bind: (iface) ->
    @_bind(new ClassBinding(iface))

  bindConstant: (name) ->
    @_bind(new ConstantBinding(name))

  _bind: (binding) ->
    @bindings.push(binding)
    binding


module.exports = Binder
