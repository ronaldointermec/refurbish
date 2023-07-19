const { Model, DataTypes } = require('sequelize');

class MicrosigaStatusMessage extends Model {

    static init(sequelize) {
        super.init({
            message: DataTypes.STRING,
            created_by: DataTypes.STRING,
            updated_by: DataTypes.STRING,
        }, { sequelize/*, freezeTableName: true */});
    }
}

module.exports = MicrosigaStatusMessage;