from pykern import pkio
from pykern.pkcollections import PKDict
from pykern.pkdebug import pkdp
from sirepo.template import template_common
from sirepo.template.lattice import LatticeUtil
import copy
import csv
import re
import sirepo.sim_data
import sirepo.simulation_db
import sirepo.template.madx

def _unique_madx_elements(data):
    def _do_unique(elem_ids):
        element_map = PKDict({e._id: e for e in data.models.elements})
        # names = set([e.name for e in data.models.elements])
        max_id = LatticeUtil.max_id(data)
        res = []
        for el_id in elem_ids:
            if el_id not in res:
                res.append(el_id)
                continue
            el = copy.deepcopy(element_map[el_id])
            # el.name = _unique_name(el.name, names)
            max_id += 1
            el._id = max_id
            data.models.elements.append(el)
            res.append(el._id)
        return res

    def _reduce_to_elements(beamline_id):
        def _do(beamline_id, res=None):
            if res is None:
                res = []
            for item_id in beamline_map[beamline_id]['items']:
                if item_id in beamline_map:
                    _do(item_id, res)
                else:
                    res.append(item_id)
            assert not list(filter(lambda e: e < 0, res)), \
                f'cannot have an element with a negative id. elements={res}'
            return res

        return _do(beamline_id)

    def _remove_unused_elements(items):
        res = []
        for el in data.models.elements:
            if el._id in items:
                res.append(el)
        data.models.elements = res

    # def _unique_name(name, names):
    #     assert name in names
    #     count = 2
    #     m = re.search(r'(\d+)$', name)
    #     if m:
    #         count = int(m.group(1))
    #         name = re.sub(r'\d+$', '', name)
    #     while f'{name}{count}' in names:
    #         count += 1
    #     names.add(f'{name}{count}')
    #     return f'{name}{count}'

    beamline_map = PKDict({
        b.id: b for b in data.models.beamlines
    })
    # TODO(e-carlin): sort
    def reflect_children(id):
        if not list(filter(lambda i: i.id in beamline_map, beamline_map)):
            # Beamline of id is composed of all elements.
            # So, just reverse elements and we're done
            beamline_map[id]['items'].reverse()
            return
        # There are items that are other beamlines.
        # Those need to be reflected too.


    for b in copy.deepcopy(list(beamline_map.values())):
        for i in filter(lambda i: i < 0, b['items']):
            v = copy.deepcopy(beamline_map[abs(i)])
            beamline_map[i] = v
            reflect_children(i)

    b = beamline_map[data.models.simulation.visualizationBeamlineId]
    b['items'] = _reduce_to_elements(b.id)
    _remove_unused_elements(b['items'])
    b['items'] = _do_unique(b['items'])
    data.models.beamlines = [b]

from pykern import pkjson
data = pkjson.load_any(pkio.open_text(pkio.py_path('./before.json')))
_unique_madx_elements(data)
print(pkjson.dump_pretty(data))

e_map = {e._id: e.name for e in data.models.elements}
for i in data.models.beamlines[0]['items']:
    print(e_map[i])
