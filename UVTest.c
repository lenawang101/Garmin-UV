#define LTR390_I2C_ADDR  0x53  // LTR-390's I2C Address
#define LTR390_MAIN_CTRL 0x00  // Control register
#define LTR390_MEAS_RATE 0x04  // Measurement rate register
#define LTR390_UV_DATA   0x10  // UV data register

#include "nrf_drv_twi.h"

static const nrf_drv_twi_t m_twi = NRF_DRV_TWI_INSTANCE(0);

void twi_init(void) {
    nrf_drv_twi_config_t config = {
        .scl = 27,  // Set to your board's SCL pin
        .sda = 26,  // Set to your board's SDA pin
        .frequency = NRF_TWI_FREQ_100K,
    };

    nrf_drv_twi_init(&m_twi, &config, NULL, NULL);
    nrf_drv_twi_enable(&m_twi);
}

uint16_t read_uv_data() {
    uint8_t reg = LTR390_UV_DATA;
    uint8_t uv_data[2];
    
    nrf_drv_twi_tx(&m_twi, LTR390_I2C_ADDR, &reg, 1, true);
    nrf_drv_twi_rx(&m_twi, LTR390_I2C_ADDR, uv_data, 2);
    
    return (uv_data[1] << 8) | uv_data[0];  // Convert to 16-bit value
}

int main(void) {
    twi_init();  // Initialize I2C
    uint16_t uv_value;

    while (1) {
        uv_value = read_uv_data();
        printf("UV Data: %u\n", uv_value);
        nrf_delay_ms(1000);
    }
}