const { Model, DataTypes } = require('sequelize');

class Status extends Model {

    static init(sequelize) {
        super.init({
            description: DataTypes.STRING,
            created_by: DataTypes.STRING,
            updated_by: DataTypes.STRING,
        }, { sequelize, freezeTableName: true });
    }
}

module.exports = Status;