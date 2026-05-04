# Pricing Configuration

## Monetization Model: Subscription (IAP)

## Subscription Group
- **Group Name**: SaySpend Premium
- **Group ID**: SaySpendPremium

## Subscription Tiers

### 1. Monthly Subscription
- **Reference Name**: Monthly Premium
- **Product ID**: `com.zzoutuo.SaySpend.monthly`
- **Price**: $2.99 per month
- **Display Name**: SaySpend Premium Monthly
- **Description**: Unlock budget, iCloud sync, and widgets
- **Localization**: English (US)

### 2. Yearly Subscription
- **Reference Name**: Yearly Premium
- **Product ID**: `com.zzoutuo.SaySpend.yearly`
- **Price**: $19.99 per year (44% savings vs monthly)
- **Display Name**: SaySpend Premium Yearly
- **Description**: Best value - unlock all premium features
- **Localization**: English (US)

### 3. Lifetime Purchase
- **Reference Name**: Lifetime Access
- **Product ID**: `com.zzoutuo.SaySpend.lifetime`
- **Price**: $39.99 one-time
- **Display Name**: SaySpend Lifetime
- **Description**: Pay once, own forever - all features
- **Localization**: English (US)

## Free Tier Features
- Voice expense input (unlimited)
- Manual expense entry
- Receipt OCR scanning
- Basic statistics (7-day view)
- Category management
- Data export (CSV)

## Premium Features
- Budget management with overspend alerts
- iCloud sync across devices
- Home screen widget (today's spending)
- Full statistics (monthly/yearly trends)
- Siri shortcuts for quick logging
- Priority support

## Free Trial
- **Duration**: 7 days
- **Type**: Free trial (auto-converts to monthly)

## Policy Pages Required
- Support Page: ✅ (Must include subscription management info)
- Privacy Policy: ✅
- Terms of Use: ✅ (REQUIRED for subscription apps)

## Apple IAP Compliance Checklist
- [ ] Auto-renewal terms included in Terms
- [ ] Cancellation instructions included
- [ ] Pricing clearly stated
- [ ] Free trial terms included
- [ ] Restore purchases functionality implemented
