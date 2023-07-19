const { Model, DataTypes } = require('sequelize');


class Part extends Model {
    static init(sequelize) {
        super.init({
            pn: DataTypes.STRING,
            description: DataTypes.STRING,
            created_by: DataTypes.STRING,
            updated_by: DataTypes.STRING,
        }, { sequelize }

        );
    }
    static associate(models) {
        this.belongsToMany(models.Localization, { foreignKey: 'part_id', through: 'part_localizations', as: 'localizations' });
        this.hasMany(models.PartLocalization, { foreignKey: "part_id" })
       // this.belongsTo(models.PartLocalization, { foreignKey: "part_id" })
    }

}

module.exports = Part;