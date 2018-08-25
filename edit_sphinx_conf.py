#!python
# -*- coding: utf-8 -*-
#
# Author      : Bhishan Poudel, Physics PhD Student, Ohio University
# Date        : Jul 04, 2017 Tue
# Ref:
# http://www.sphinx-doc.org/en/stable/theming.html
#
# Imports
import time
import os
import subprocess

def edit_sphinx_conf_py():
    """Edit sphinx conf.py file."""

    conf, conf2 = 'docs/source/conf.py', 'docs/source/conf2.py'
    if os.path.isfile(conf): subprocess.call('cp %s %s '% (conf, conf2), shell=True)
    olds = [r'# import os', 
    r'# import sys',
    r"# sys.path.insert(0, os.path.abspath('.'))",
    r"html_theme = 'alabaster'"]
    
    news = [r'import os', 
    r'import sys',
    r"sys.path.insert(0, os.path.abspath('.'))",
    r"html_theme = 'classic'"]
    
    html_theme_options = ["html_theme_options = { 'linkcolor': '#808000',",
    "'collapsiblesidebar': True,", 
    "'sidebarbgcolor': 'fuchia',", 
    "'sidebartextcolor': 'teal',", 
    "'sidebarlinkcolor': 'gray',", 
    "'relbarbgcolor': '#5D6D7E',", 
    "'externalrefs': True",
    "}",
    ""
    ]
        
    with open(conf2, 'r') as fi:
        data = fi.readlines()
        
        # uncomment modules
        for i, line in enumerate(data):
            for j in range(len(olds)):
                if olds[j] in line:
                    data[i] = news[j]
                    # print(data[i])
        
        # remove alabaster html sidebar
        for i, line in enumerate(data):
            if 'html_sidebars' in line:
                for j in range(9):
                    # data[i+j] = ""
                    data[i+j] = html_theme_options[j]
        
        # write chaged data
        with open(conf,'w') as fo:
            for line in data:
                print(line.strip('\n'), file=fo)
        
    os.remove(conf2)
    print('Editing file: ', conf)

if __name__ == '__main__':
    edit_sphinx_conf_py()
