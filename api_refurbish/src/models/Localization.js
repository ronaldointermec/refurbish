const { Model, DataTypes } = require('sequelize');

class Localization extends Model {

    static init(sequelize) {
        super.init({
            address: DataTypes.STRING,
            created_by: DataTypes.STRING,
            updated_by: DataTypes.STRING,
        },
            { sequelize }
        )
    }

    static associate(models) {
        this.belongsToMany(models.Part, { foreignKey: 'localization_id', through: 'part_localizations', as: 'parts' });
    }
}

module.exports = Localization;