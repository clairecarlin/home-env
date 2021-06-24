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
        names = set([e.name for e in data.models.elements])
        max_id = LatticeUtil.max_id(data)
        res = []
        for el_id in elem_ids:
            if el_id not in res:
                res.append(el_id)
                continue
            el = copy.deepcopy(element_map[el_id])
            el.name = _unique_name(el.name, names)
            max_id += 1
            el._id = max_id
            data.models.elements.append(el)
            res.append(el._id)
        return res

    def _insert_items(old_items, new_items, beamline, index):
        beamline['items'] = old_items[:index] + \
            new_items + old_items[index + 1:]

    def _reflect_children(id_to_reflect, index, beamline, reflecting_grandchildren=False):
        if abs(id_to_reflect) not in beamline_map:
            # It is an element, we're done.
            return
        if id_to_reflect < 0 and reflecting_grandchildren:
            # TODO(e-carlin): This is may be wrong. The manual says "Sub-lines
            # of reflected lines are also reflected" but, it doesn't say if a
            # sub-line of the sub-line is itself reflected then the reflections
            # cancel eachother out. It seems to work but could be wrong.
            beamline['items'][index] = abs(id_to_reflect)
            return
        n = beamline_map[abs(id_to_reflect)]['items'].copy()
        n.reverse()
        _insert_items(beamline['items'], n, beamline_map[beamline.id], index)
        for i, e in enumerate(n):
            _reflect_children(e, index + i, b, reflecting_grandchildren=True)

    def _reduce_to_elements_with_reflection(beamline):
        """Reduce a beamline to just elements while reflecting negative sub-lines

        An item that is negative means it and all of it's sublines
        need to be reflected (reverse the order of elements).
        Manual section on "Reflection and Repetition":
        https://mad.web.cern.ch/mad/webguide/manual.html#Ch13.S3
        """
        for i, e in enumerate(beamline['items'].copy()):
            if e >= 0:
                if e in beamline_map:
                    _insert_items(
                        beamline['items'],
                        beamline_map[e]['items'],
                        beamline,
                        i,
                    )
                    break
                continue
            _reflect_children(e, i, beamline)
            break
        else:
            return
        # Need to start over because items have changed out from underneath us
        _reduce_to_elements_with_reflection(beamline_map[data.models.simulation.visualizationBeamlineId])

    def _remove_unused_elements(items):
        res = []
        for el in data.models.elements:
            if el._id in items:
                res.append(el)
        data.models.elements = res

    def _unique_name(name, names):
        assert name in names
        count = 2
        m = re.search(r'(\d+)$', name)
        if m:
            count = int(m.group(1))
            name = re.sub(r'\d+$', '', name)
        while f'{name}{count}' in names:
            count += 1
        names.add(f'{name}{count}')
        return f'{name}{count}'

    beamline_map = PKDict({
        b.id: b for b in data.models.beamlines
    })
    b = beamline_map[data.models.simulation.visualizationBeamlineId]
    _reduce_to_elements_with_reflection(b)
    _remove_unused_elements(b['items'])
    b['items'] = _do_unique(b['items'])
    data.models.beamlines = [b]
from pykern import pkjson
data = pkjson.load_any(pkio.open_text(pkio.py_path('./before.json')))
_unique_madx_elements(data)
print(pkjson.dump_pretty(data))

e_map = {e._id: e.original_id for e in data.models.elements}
for i in data.models.beamlines[0]['items']:
    print(e_map[i])
