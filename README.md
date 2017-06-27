# MediaBank
The right place for your digital assets.
EPrints implementation. Works on EPrints vanilla 3.3.10 - 3.3.15

# SuperPowers
Few plugins have been created for this EPrints "flavour". Among them

- [paypal](https://github.com/eprintsug/paypal)
- iipimage
- [static map generator](https://github.com/unesco/staticmap)
- [LDAP login](https://github.com/eprintsug/ldap_login)
- [heavy bootstrap customisation](https://github.com/eprintsug/bootstrap)
- [sexy slider](https://github.com/eprintsug/carousel/tree/bootstrap)

If you find any issue or you improve the code, please share it with us!

# Install
On a debian system (I use Ubuntu):

- Install mod_perl for Apache2 (or play with Nginx, so far I have no instruction)
    ```
    sudo apt install libapache2-mod-perl2
    ```
- Clone EPrints and make sure you are at the latest version
    ```
    git clone https://github.com/eprints/eprints.git
    git checkout v3.3.15
    cd eprints
    ```
- Get this archive
    ```
    git submodule add https://github.com/unesco/mediabank.git archives/mediabank
    ```
- install some extra perl modules:
    - cpan install URI
    - cpan install DBI
    - cpan install JSON
    - cpan install Text::Unidecode
    - cpan install Term::ReadKey
    - cpan install XML::NamespaceSupport
    - cpan install Net::LDAP
    - cpan install Image::Size
    - cpan install Geo::Geonames
- Customize:
    ``` 
    vi archives/mediabank/cfg/cfg.d/10_core.pl
    vi archives/mediabank/cfg/cfg.d/database.pl
    vi archives/mediabank/cfg/cfg.d/zzz_devel.pl
    ```
- Create /etc/apache2/conf-available/eprints.conf
    ```
    <IfModule perl_module>
        Include /home/denix/git/eprints/cfg/eprints.conf
        <IfModule mod_ssl>
                Include /your/git/repo/git/eprints/cfg/eprints_ssl.conf
        </IfModule>
    </IfModule>
    ```
- install multilang fields
    ```
    wget http://bazaar.eprints.org/cgi/export/eprint/452/EPM/multilang_fields-0.0.9.epm
    epm install multilang_fields-0.0.9.epm
    ```
- install bootstrap
- run the command:
    ```
    cd cfg/themes/bunesco/less/ && lessc --clean-css="--compatibility=ie8 --advanced" style.less ../static/bootstrap_assets/Styles/main.css && cd ~/archives/mediabank/
    ```
