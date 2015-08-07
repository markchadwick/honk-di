inject = (cls, args...) ->
  if cls is undefined
    throw Error('Cannot inject undefined')
  if cls.scope?.toUpperCase() is 'SINGLETON' and args.length
    throw Error('Cannot assign arguments to a singleton')

  _requiresInjection_: true
  cls:  cls
  args: args


module.exports = inject
