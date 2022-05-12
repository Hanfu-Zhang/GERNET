import os
import pymysql

basedir = os.path.abspath(os.path.dirname(__file__))


class Config:
    SECRET_KEY = os.environ.get('SECRET_KRY') or 'qg&&hf'
    SQLALCHEMY_TRACK_MODIFICATIONS = False

    # 静态方法，可以在不创建类实例的情况下调用方法,这样做的好处是执行效率比较高
    @staticmethod
    def init_app(app):
        pass


class DevelopmentConfig(Config):
    DEBUG = True
    SQLALCHEMY_DATABASE_URI = os.environ.get(
        'DATABASE_URL') or 'mysql+pymysql://GERNET:GERNET@47.103.81.223:3306/gernet'


class ProductionConfig(Config):
    SQLALCHEMY_DATABASE_URI = os.environ.get(
        'DATABASE_URL') or 'mysql+pymysql://GERNET:GERNET@47.103.81.223:3306/gernet'


config = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,

    'default': DevelopmentConfig
}
