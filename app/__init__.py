from flask import Flask, render_template
from config import config
from flask_sqlalchemy import SQLAlchemy
from flask_bootstrap import Bootstrap

bootstrap = Bootstrap()
db = SQLAlchemy()


def create_app(config_name):
    app = Flask(__name__)
    app.config.from_object(config[config_name])
    config[config_name].init_app(app)

    bootstrap.init_app(app)
    db.init_app(app)

    # 在工厂函数 create_app() 中 将蓝本注册到应用上
    from app.main import main as main_blueprint
    app.register_blueprint(main_blueprint, url_prefix='/')

    return app
