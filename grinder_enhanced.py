# coding:utf-8
import os
import re
import sys


class UnicodeStreamFilter:
    def __init__(self, target):
        self.target = target
        self.encoding = 'utf-8'
        self.errors = 'replace'
        self.encode_to = self.target.encoding
    def write(self, s):
        if type(s) == str:
            s = s.decode("utf-8")
        s = s.encode(self.encode_to, self.errors).decode(self.encode_to)
        self.target.write(s)

if sys.stdout.encoding == 'cp936':
    sys.stdout = UnicodeStreamFilter(sys.stdout)


print "+++++++++++++++++++++++++++"
print "+ SCRIPT_NAME:", sys.argv[0].split(os.sep)[-1], "+"
print "+++++++++++++++++++++++++++"

ENHANCED_GRINDER_HOME = os.getcwd()
SPLIT_LINE = "---------------------------"

print 'The Current Path is "%s"' % ENHANCED_GRINDER_HOME
print SPLIT_LINE


def get_config(config_file):
    config_dict = {"java_home": r'JAVA_HOME="(.*?)"',
                   "grinder_home": r'GRINDER_HOME="(.*?)"',
                   "default_grinder_properties": r'DEFAULT_GRINDER_PROPERTIES="(.*?)"',
                   }

    if not os.path.exists(config_file):
        config_dict.clear()
        return config_dict

    config_file = open(config_file)
    config_content = config_file.read()
    for key, value in config_dict.items():
        pattern = re.compile(value)
        if pattern.search(config_content):
            config_dict[key] = pattern.findall(config_content)[0].strip()
        else:
            config_dict[key] = ""
    return config_dict


def path_preprocess(path):
    if not os.path.exists(path):
        path = ""
    else:
        path = os.path.abspath(path)
    return path


def find_system_java():
    java_path = ""
    if os.name == "nt":
        if os.system("java -version >nul 2>nul") == 0:
            java_path = "java"
    elif os.name == "posix":
        if os.system("java -version >/dev/null 2>/dev/null") == 0:
            java_path = "java"
    else:
        # other platform?
        pass
    return java_path


def get_java_path(java_home):
    if not java_home:
        print "JAVA_HOME is not set!"
    else:
        java_home = path_preprocess(java_home)
        if java_home:
            java_path = os.sep.join([java_home, "bin", "java"])
            if os.name == "nt":
                if not os.system('"' + java_path + '"' + ' -version >nul 2>nul') == 0:
                    print "JAVA_HOME is not correctly set!"
                    java_home = ""
            elif os.name == "posix":
                if not os.system(java_path + " -version >/dev/null 2>/dev/null") == 0:
                    print "JAVA_HOME is not correctly set!"
                    java_home = ""
            else:
                # other platform?
                pass
    if not java_home:
        java_path = find_system_java()
        if java_path:
            print "Use system java."
        else:
            print "No java is available!"
            java_home = specify_java_home()
            java_path = os.sep.join([java_home, "bin", "java"])
    print 'The java path is "%s"' % java_path
    print SPLIT_LINE
    return java_path


def specify_java_home():
    while True:
        recieved_java_home = raw_input("Enter the path of java home:").strip()
        if not recieved_java_home:
            print "No java is available!"
            print "You must specify one manually!"
        else:
            user_java_home = path_preprocess(user_java_home)
            if not user_java_home:
                print "The path [%s] does not exist! Please re-enter." % recieved_java_home
                continue
            user_java_path = os.sep.join([user_java_home, "bin", "java"])
            if os.name == "nt":
                if not os.system('"' + user_java_path + '"' + ' -version >nul 2>nul') == 0:
                    print "JAVA_HOME is not correctly set!"
                    java_path = ""
                else:
                    break
            elif os.name == "posix":
                if not os.system(user_java_path + " -version >/dev/null 2>/dev/null") == 0:
                    print "JAVA_HOME is not correctly set!"
                    java_path = ""
                else:
                    break
            else:
                # other platform?
                pass
    print 'The JAVA_HOME is set to "%s"' % user_java_home
    print SPLIT_LINE
    return user_java_home


def get_grinder_home(grinder_home):
    if not grinder_home:
        print "GRINDER_HOME is not set!"
    else:
        grinder_home = path_preprocess(grinder_home)
        if not grinder_home:
            print "GRINDER_HOME is not correctly set!"
    if not grinder_home:
        grinder_home = "grinder-3.11"
        grinder_home = path_preprocess(grinder_home)
        if grinder_home:
            print "Use system setting."
        else:
            print "No grinder is available!"
            grinder_home = specify_grinder_home()
    print 'The grinder home is "%s"' % grinder_home
    print SPLIT_LINE
    return grinder_home


def specify_grinder_home():
    while True:
        recieved_grinder_home = raw_input("Enter the path of grinder home:").strip()
        if not recieved_grinder_home:
            print "No grinder is available!"
            print "You must specify one manually!"
        else:
            user_grinder_home = path_preprocess(recieved_grinder_home)
            if not os.path.exists(os.sep.join([user_grinder_home, "lib", "grinder.jar"])):
                print "The path [%s] does not exist! Please re-enter." % recieved_grinder_home
            else:
                break
    print 'The GRINDER_HOME is set to "%s"' % user_grinder_home
    print SPLIT_LINE
    return user_grinder_home


def get_default_grinder_properties(default_grinder_properties):
    if not default_grinder_properties:
        print "DEFAULT_GRINDER_PROPERTIES is not set!"
    else:
        default_grinder_properties = path_preprocess(default_grinder_properties)
        if not default_grinder_properties:
            print "DEFAULT_GRINDER_PROPERTIES is not correctly set!"
    if not default_grinder_properties:
        default_grinder_properties = "grinder.properties"
        default_grinder_properties = path_preprocess(default_grinder_properties)
        if default_grinder_properties:
            print "Use system setting."
        else:
            "No default grinder.properties is available!"
    print 'The default grinder.properties is "%s"' % default_grinder_properties
    print SPLIT_LINE
    return default_grinder_properties


def specify_grinder_properties(default_grinder_properties):
    while True:
        recieved_grinder_properties = raw_input("Enter the path of your grinder.properties:").strip()
        if not recieved_grinder_properties:
            if not default_grinder_properties:
                print "No Default grinder.properties is available!"
                print "You must specify one manually!"
            else:
                user_grinder_properties = default_grinder_properties
                print "Use the default grinder.properties."
                break
        else:
            user_grinder_properties = path_preprocess(recieved_grinder_properties)
            if user_grinder_properties[-18] != "grinder.properties":
                user_grinder_properties = user_grinder_properties + os.sep + "grinder.properties"
                user_grinder_properties = path_preprocess(user_grinder_properties)
                if not user_grinder_properties:
                    print "The path [%s] does not exist! Please re-enter." % recieved_grinder_properties
                else:
                    break
    print 'The user grinder.properties is "%s"' % user_grinder_properties
    print SPLIT_LINE
    return user_grinder_properties


def get_properties(user_grinder_properties):
    property_dict = {"script": r'grinder.script = (.*?)\n',
                     "processes": r'grinder.processes = (.*?)\n',
                     "threads": r'grinder.threads = (.*?)\n',
                     "runs": r'grinder.runs = (.*?)\n',
                     "duration": r'grinder.duration = (.*?)\n'}
    if not os.path.exists(user_grinder_properties):
        property_dict.clear()
        return property_dict

    properties_file = open(user_grinder_properties)
    properties_content = properties_file.read()

    for key, value in property_dict.items():
        pattern = re.compile(value)
        if pattern.search(properties_content):
            property_dict[key] = pattern.findall(properties_content)[0].strip()
        else:
            property_dict[key] = ""
        print key, "= %s" % property_dict[key]

    return property_dict


def classpath_preprocess(path):
    path = path_preprocess(path)
    if path:
        f = open(os.sep.join([path, "test.jar"]), 'w')
        f.write("This a assistant jar file which ensures the lib direcotry is not empty.")
        f.close()
        return path


def get_classpath(grinder_home, script_home):
    classpath = "."
    grinder_lib = os.sep.join([grinder_home, "lib"])
    script_lib = script_home
    user_lib = os.sep.join([ENHANCED_GRINDER_HOME, "lib"])
    for lib_path in [grinder_lib, script_lib, user_lib]:
        lib_path = classpath_preprocess(lib_path)
        if lib_path:
            if os.name == "nt":
                classpath += ";" + lib_path + os.sep + "*"
            elif os.name == "posix":
                classpath += ":" + lib_path + os.sep + "*"
            else:
                # other platform
                pass
    print 'The classpath is "%s"' % classpath
    print SPLIT_LINE
    return classpath


def main():
    config_dict = get_config("conf/enhanced_grinder.conf")
    if not config_dict:
        print "No Config File is found!"
        print SPLIT_LINE
    java_path = get_java_path(config_dict.get("java_home", ""))
    grinder_home = get_grinder_home(config_dict.get("grinder_home", ""))
    default_grinder_properties = get_default_grinder_properties(config_dict.get("default_grinder_properties", ""))
    user_grinder_properties = specify_grinder_properties(default_grinder_properties)

    property_dict = get_properties(user_grinder_properties)
    print SPLIT_LINE
    script = property_dict.get("script")

    grinder_properties_path = os.path.split(user_grinder_properties)[0]
    script_relative_path = os.path.split(script)[0]
    script_home = os.sep.join([grinder_properties_path, script_relative_path])

    classpath = get_classpath(grinder_home, script_home)

    os.chdir(script_home)
    if os.name == "nt":
        cmd = 'call "' + java_path + '"' + " -cp " + '"' + classpath + '"' + " net.grinder.Grinder " + '"' + user_grinder_properties + '"'
        os.system(cmd)
    elif os.name == "posix":
        cmd = java_path + " -cp " + '"' + classpath + '"' + " net.grinder.Grinder " + '"' + user_grinder_properties + '"'
        os.system(cmd)
    else:
        # other platform
        pass

    for jar_path in classpath.split(";"):
        if jar_path.endswith("*"):
            jar_path = jar_path.replace("*", "test.jar")
            os.remove(jar_path)

    if os.name == "nt":
        print "Press Any Key To Close This Window"
        cmd = "pause>nul"
        os.system(cmd)


if __name__ == "__main__":
    main()
