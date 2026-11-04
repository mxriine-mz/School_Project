#!/bin/bash
# liste des jobs YARN termines (id, etat, duree s, nom)
curl -s "http://localhost:8088/ws/v1/cluster/apps?states=FINISHED,FAILED,KILLED" | python -c "
import json,sys
for a in sorted(json.load(sys.stdin)['apps']['app'], key=lambda a:a['startedTime']):
    print '%s\t%s\t%s\t%.1f\t%s' % (a['id'], a['state'], a['finalStatus'], a['elapsedTime']/1000.0, a['name'][:80].replace('\n',' '))
"
