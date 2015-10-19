#!/usr/bin/python

import sys
import os.path
import xml.etree.ElementTree as etree
import re;
import os;
import shutil;
from os.path import basename;

pom='pom.xml';
deployDir = None;

def getModules(fname):
    result = [];
    tree = etree.parse(fname);
    root = tree.getroot();

    namespace = re.search('\{.*\}', root.tag).group(0);

    modules = root.find(namespace + 'modules');
    if moudles == None:
        return None;

    moduleList = modules.findall(namespace + 'module');


    for m in moduleList:
        result.append(m.text);

    return result;


def getId(fname):
    tree = etree.parse(fname);
    root = tree.getroot();

    namespace = re.search('\{.*\}', root.tag).group(0);

    groupId = root.find(namespace + 'groupId');
    artifactId = root.find(namespace + 'artifactId');

    if groupId != None:
        groupId = groupId.text;
    else:
        groupId = root.find(namespace + 'parent/'+namespace + 'groupId');
        if groupId != None:
            groupId = groupId.text;

    if artifactId != None:
        artifactId = artifactId.text;

    # for child in root.findall('file'):
    # if (len(child)>0):
    #     print('in ' + child.attrib['name']);
    #     for err in child:
    #         print('[' + err.attrib['severity'] + '] line ' + err.attrib['line'] + ' ' + err.attrib['message']);

    return groupId, artifactId

def isMatch(groupId, artifactId, fileName):

    idMatch = re.compile(groupId+'.'+artifactId + '|' + artifactId);
    result = idMatch.match(fileName);


    if result != None:
        substr = fileName[result.end()+1:];

        if substr[:1].isdigit():
            return True;
        else:
            return False;

    # artifactIdMatch = re.compile(artifactId);
    # result = artifactIdMatch.match(fileName);

    return result != None;

def listFileMatch(groupId, artifactId, path):
    matchedFileList = [];
    for file in os.listdir(path):
        if file.endswith(".jar") and not (file.endswith("tests.jar")):
            if isMatch(groupId, artifactId, file):
                matchedFileList.append(file);

    return matchedFileList;


def deployFile(groupId, artifactId, path, file, targetDir, backupDir):

    duplicatedFileList = listFileMatch(groupId, artifactId, targetDir);

    for f in duplicatedFileList:
        src = targetDir +"/" + f;
        dst = backupDir + "/" + f;
        print '[backup] ' + src + ' to ' + "\n" + dst, '\n';
        shutil.move(src, dst);

    src = path +"/" + file;
    dst = targetDir + "/" + file;
    print '[deploy] ' + src + ' to ' + "\n" + dst, '\n';
    shutil.copyfile(src, dst);

def deployModule(path):
    global deployDir;
    global deployPluginsDir;
    global deployPluginsBackupDir;

    pom = path + "/pom.xml";
    targetDir = path + "/target";

    print '------------------------------------------------';
    print '[process] ' + pom;


    if os.path.isfile(pom) == False:
        print "[error] cannot find " + pom;
        return;



    if os.path.exists(targetDir) != True:
        print "[warning] cannot find " + targetDir;
    else:

        jarFileName = '';
        groupId, artifactId = getId(pom);
        print '[groupId]:', groupId;
        print '[artifactId]:', artifactId
        print '';
        matchedFileList = listFileMatch(groupId, artifactId, targetDir);

        if matchedFileList != None:
            for f in matchedFileList:
                deployFile(groupId, artifactId, targetDir, f, deployPluginsDir, deployPluginsBackupDir);

    moduleList = getModuleList(pom);

    if moduleList != None:
        for m in moduleList:
            deployModule(path + "/" + m);

def getModuleList(pom):

    moduleList = [];
    tree = etree.parse(pom);
    root = tree.getroot();

    namespace = re.search('\{.*\}', root.tag).group(0);

    modules = root.findall(namespace + 'modules/' + namespace + 'module');

    if modules != None:
        for m in modules:
            moduleList.append(m.text);

    return moduleList;


deployDir = os.getenv('DEPLOYDIR', None);

if len(sys.argv) > 1:
    deployDir = sys.argv[1];

print 'Deploy dir: ', deployDir;


if deployDir == None:
    print "No deploy directory is given";
    print "e.g. ";
    print "export DEPLOYDIR=integration/distributions/base/target/distributions-base-0.2.0-SNAPSHOT-osgipackage/opendaylight"
    print "deploy.py integration/distributions/base/target/distributions-base-0.2.0-SNAPSHOT-osgipackage/opendaylight";
    exit(1);

if os.path.exists(deployDir) != True:
    print "deploy direcotry doesn't exist";
    exit(1);

if os.path.isdir(deployDir) != True:
    print "deploy direcotry:" + deployDir + " is not a directory";
    exit(1);

deployPluginsDir = deployDir + '/plugins';
if os.path.exists(deployPluginsDir) != True:
    print "deploy plugins direcotry doesn't exist";
    exit(1);

deployPluginsBackupDir = deployPluginsDir + "/backup";
if os.path.exists(deployPluginsBackupDir) != True:
    os.makedirs(deployPluginsBackupDir);

if os.path.isfile(pom) == False:
    print "cannot find " + pom;
    exit(1);

deployModule('.');


