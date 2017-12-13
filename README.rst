EGMA Stream Backend
===================
Provides structure for developing EGMA Stream

Specifications
^^^^^^^^^^^^^^
* Ubuntu 16 "Xenial"
* Postgresql 9.6
* MailCatcher
* Python 3.5

Supported Operating Systems
---------------------------
* Linux Distros
* Windows 7/10
* macOS

Requirements
--------------

* `Vagrant 1.9.6 <http://www.python.org/>`_

* `VirtualBox 5.1.26 <https://www.virtualbox.org/wiki/Downloads>`_

Getting Started
^^^^^^^^^^^^^^^^
Clone the Repo

.. code-block:: bash

    git clone https://github.com/mpdevilleres/egma-vagrant-dev.git

As the development requires accessing private repo, you will need to add your credential to ``bootstrap.sh``

.. code-block:: bash

    . . .
    GITHUB_USER=<your github username>
    GITHUB_PASS=<your github password>
    . . .

Run vagrant to provision a development environment, this may take some time

.. code-block:: bash

    vagrant up

That's it you are ready now to start contributing.

Basic Commands
--------------
For ease of use, open 1 Terminal for Backend and another 1 for Frontend

Backend/Django
^^^^^^^^^^^^^^
It is better to stay in the working directory (``/vagrant/backend``), so that your commands would be short.

.. code-block:: bash

    cd /vagrant/backend

Setting Up Your Super Users
---------------------------

.. code-block:: bash

    python3 manage.py createsuperuser

Run Backend Server
------------------

.. code-block:: bash

    python3 manage.py runserver 0.0.0.0:8080

Test coverage
-------------

To run the tests, check your test coverage, and generate an HTML coverage report

.. code-block:: bash

    coverage run manage.py test
    coverage html
    open htmlcov/index.html

Running tests with py.test
--------------------------

.. code-block:: bash

    py.test

Frontend/AngularJS
^^^^^^^^^^^^^^^^^^
It is better to stay in the working directory (``/vagrant/frontend/``), so that your commands would be short.

.. code-block:: bash

    cd /vagrant/frontend/

Run Frontend Server
-------------------

.. code-block:: bash

    ng server -o

Build Frontend
--------------

.. code-block:: bash

    ng build -prod

Deployment
^^^^^^^^^^

Deployment would be controlled through CI, each commit will be build accordingly before release.
