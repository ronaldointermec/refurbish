const { Model, DataTypes } = require('sequelize')

class MicrosigaLoan extends Model {
    
    static init(sequelize){
        super.init({
            order_id: DataTypes.INTEGER,
            status_id: DataTypes.INTEGER,
            msn:DataTypes.STRING,
            pn: DataTypes.STRING,
            position: DataTypes.STRING,
            description: DataTypes.STRING,
            created_by: DataTypes.STRING,
            updated_by: DataTypes.STRING,
        },{sequelize}
        );
    }
    
    static associate(models){
        this.belongsTo(models.Order,{foreignKey:'order_id', as: 'order'});
       // this.belongsTo(models.Status, { foreignKey: "status_id", as: 'status' });
        this.belongsTo(models.MicrosigaStatusMessage, { foreignKey: "status_id", as: 'status' });
    }

}

module.exports = MicrosigaLoan;

