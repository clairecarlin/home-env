import datetime
import json  # noqa F401

import databroker
import matplotlib.pyplot as plt
import numpy as np  # noqa F401
from bluesky.callbacks import best_effort
from bluesky.run_engine import RunEngine
from databroker import Broker
from ophyd.utils import make_dir_tree

from sirepo_bluesky.shadow_handler import ShadowFileHandler
from sirepo_bluesky.srw_handler import SRWFileHandler

RE = RunEngine({})
bec = best_effort.BestEffortCallback()
RE.subscribe(bec)

# MongoDB backend:
db = Broker.named('rsbluesky')  # mongodb backend
try:
    databroker.assets.utils.install_sentinels(db.reg.config, version=1)
except Exception:
    pass

RE.subscribe(db.insert)
db.reg.register_handler('srw', SRWFileHandler, overwrite=True)
db.reg.register_handler('shadow', ShadowFileHandler, overwrite=True)
db.reg.register_handler('SIREPO_FLYER', SRWFileHandler, overwrite=True)

plt.ion()

root_dir = '/tmp/sirepo_det_data'
_ = make_dir_tree(datetime.datetime.now().year, base_path=root_dir)

import sirepo_bluesky.sirepo_detector as sd
import bluesky.plans as bp
sirepo_det = sd.SirepoDetector(sim_id='<sim_id>')
sirepo_det.select_optic('Aperture')
param1 = sirepo_det.create_parameter('horizontalSize')
param2 = sirepo_det.create_parameter('verticalSize')
sirepo_det.read_attrs = ['image', 'mean', 'photon_energy']
sirepo_det.configuration_attrs = ['horizontal_extent', 'vertical_extent', 'shape']
RE(bp.grid_scan([sirepo_det],
                param1, 0, 1, 10,
                param2, 0, 1, 10,
                True))
