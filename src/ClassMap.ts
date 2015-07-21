var classMapId = 0;


class ClassMap {

  private _nextId:    number;
  private _classes:   {[id: number]: any};
  private _fieldName: string;

  constructor() {
    this._nextId = 1;
    this._classes = {};
    this._fieldName = `_honk_clsid_${classMapId++}`;
  }

  get<T>(cls: {new(): T;}): T {
    var index = cls[this._fieldName];
    return this._classes[index];
  }

  set<T>(cls: {new(): T}, instance: T) {
    var currently = cls[this._fieldName];
    if(currently) return;

    var id = this._nextId++;
    cls[this._fieldName] = id;
    this._classes[id] = instance;
  }

}

var map = new ClassMap();
map.set(ClassMap, map);
var pants: ClassMap = map.get(ClassMap);
