0.1.9
-----
- [isuftin@usgs.gov] - Added sensitivity to templates
- [isuftin@usgs.gov] - Fixed server opts updating
- [isuftin@usgs.gov] - Removed the `application_name` attribute
- [isuftin@usgs.gov] - Updated how encrypted data bags are accessed
- [isuftin@usgs.gov] - Added more attributes to put into context.xml and server.xml

0.1.8
-----
- Removed requirement for specifying key location. Using default key location as according to Chef
- No longer taking certificates baked into encrypted data bag. Certificates are now either created on the fly or provided on the file system

0.1.7
-----
- Updated default Tomcat version to install
- Added more CentOS options to Test Kitchen
- Updated Test Kitchen CentOS boxes to use mainly Bento box versions
- Added STIG testing option to Test Kitchen
- Moved default Java installation options to be defined outside of attributes (like in Test Kitchen)
- Moved some passwords into an encrypted data bag (and included documentation)
- Added more Serverspec testing