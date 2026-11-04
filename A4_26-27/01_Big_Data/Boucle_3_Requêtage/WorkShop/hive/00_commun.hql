-- Reglages de session communs aux deux designs (environnement, pas optimisation).
-- La VM QuickStart livre des conteneurs MapReduce de 128 Mo (heap 50 Mo) et
-- mapreduce.job.reduces=1 : trop petit pour 25 M de lignes. On donne les memes
-- ressources aux deux bases pour que la comparaison porte sur le design physique.
SET mapreduce.map.memory.mb=1024;
SET mapreduce.map.java.opts=-Xmx820m;
SET mapreduce.reduce.memory.mb=1024;
SET mapreduce.reduce.java.opts=-Xmx820m;
SET yarn.app.mapreduce.am.resource.mb=512;
SET mapreduce.job.reduces=-1;
SET hive.exec.reducers.max=8;
