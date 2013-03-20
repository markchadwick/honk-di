

inject = (cls, args...) ->
  _requiresInjection_: true
  cls:  cls
  args: args

module.exports = inject
