CREATE OR REPLACE FUNCTION copySo(pSoheadid INTEGER,
                                  pSchedDate DATE) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _soheadid INTEGER;
  _soitemid INTEGER;
  _soitem RECORD;

BEGIN

  SELECT NEXTVAL('cohead_cohead_id_seq') INTO _soheadid;

  INSERT INTO cohead
  ( cohead_id,
    cohead_number,
    cohead_cust_id,
    cohead_custponumber,
    cohead_type,
    cohead_orderdate,
    cohead_warehous_id,
    cohead_shipto_id,
    cohead_shiptoname,
    cohead_shiptoaddress1,
    cohead_shiptoaddress2,
    cohead_shiptoaddress3,
    cohead_shiptoaddress4,
    cohead_shiptoaddress5,
    cohead_salesrep_id,
    cohead_terms_id,
    cohead_fob,
    cohead_shipvia,
    cohead_shiptocity,
    cohead_shiptostate,
    cohead_shiptozipcode,
    cohead_freight,
    cohead_misc,
    cohead_imported,
    cohead_ordercomments,
    cohead_shipcomments,
    cohead_shiptophone,
    cohead_shipchrg_id,
    cohead_shipform_id,
    cohead_billtoname,
    cohead_billtoaddress1,
    cohead_billtoaddress2,
    cohead_billtoaddress3,
    cohead_billtocity,
    cohead_billtostate,
    cohead_billtozipcode,
    cohead_misc_accnt_id,
    cohead_misc_descrip,
    cohead_commission,
    cohead_miscdate,
    cohead_holdtype,
    cohead_packdate,
    cohead_prj_id,
    cohead_wasquote,
    cohead_lastupdated,
    cohead_shipcomplete,
    cohead_created,
    cohead_creator,
    cohead_quote_number,
    cohead_billtocountry,
    cohead_shiptocountry,
    cohead_curr_id,
    cohead_calcfreight,
    cohead_shipto_cntct_id,
    cohead_shipto_cntct_honorific,
    cohead_shipto_cntct_first_name,
    cohead_shipto_cntct_middle,
    cohead_shipto_cntct_last_name,
    cohead_shipto_cntct_suffix,
    cohead_shipto_cntct_phone,
    cohead_shipto_cntct_title,
    cohead_shipto_cntct_fax,
    cohead_shipto_cntct_email,
    cohead_billto_cntct_id,
    cohead_billto_cntct_honorific,
    cohead_billto_cntct_first_name,
    cohead_billto_cntct_middle,
    cohead_billto_cntct_last_name,
    cohead_billto_cntct_suffix,
    cohead_billto_cntct_phone,
    cohead_billto_cntct_title,
    cohead_billto_cntct_fax,
    cohead_billto_cntct_email,
    cohead_taxzone_id,
    cohead_taxtype_id,
    cohead_ophead_id,
    cohead_status,
    cohead_saletype_id,
    cohead_shipzone_id )
  SELECT
    _soheadid,
    fetchSoNumber(),
    cohead_cust_id,
    cohead_custponumber,
    cohead_type,
    CURRENT_DATE,
    cohead_warehous_id,
    cohead_shipto_id,
    cohead_shiptoname,
    cohead_shiptoaddress1,
    cohead_shiptoaddress2,
    cohead_shiptoaddress3,
    cohead_shiptoaddress4,
    cohead_shiptoaddress5,
    cohead_salesrep_id,
    cohead_terms_id,
    cohead_fob,
    cohead_shipvia,
    cohead_shiptocity,
    cohead_shiptostate,
    cohead_shiptozipcode,
    cohead_freight,
    cohead_misc,
    FALSE,
    cohead_ordercomments,
    cohead_shipcomments,
    cohead_shiptophone,
    cohead_shipchrg_id,
    cohead_shipform_id,
    cohead_billtoname,
    cohead_billtoaddress1,
    cohead_billtoaddress2,
    cohead_billtoaddress3,
    cohead_billtocity,
    cohead_billtostate,
    cohead_billtozipcode,
    cohead_misc_accnt_id,
    cohead_misc_descrip,
    cohead_commission,
    cohead_miscdate,
    cohead_holdtype,
    COALESCE(pSchedDate, cohead_packdate),
    cohead_prj_id,
    FALSE,
    cohead_lastupdated,
    cohead_shipcomplete,
    NULL,
    getEffectiveXtUser(),
    NULL,
    cohead_billtocountry,
    cohead_shiptocountry,
    cohead_curr_id,
    cohead_calcfreight,
    cohead_shipto_cntct_id,
    cohead_shipto_cntct_honorific,
    cohead_shipto_cntct_first_name,
    cohead_shipto_cntct_middle,
    cohead_shipto_cntct_last_name,
    cohead_shipto_cntct_suffix,
    cohead_shipto_cntct_phone,
    cohead_shipto_cntct_title,
    cohead_shipto_cntct_fax,
    cohead_shipto_cntct_email,
    cohead_billto_cntct_id,
    cohead_billto_cntct_honorific,
    cohead_billto_cntct_first_name,
    cohead_billto_cntct_middle,
    cohead_billto_cntct_last_name,
    cohead_billto_cntct_suffix,
    cohead_billto_cntct_phone,
    cohead_billto_cntct_title,
    cohead_billto_cntct_fax,
    cohead_billto_cntct_email,
    cohead_taxzone_id,
    cohead_taxtype_id,
    cohead_ophead_id,
    cohead_status,
    cohead_saletype_id,
    cohead_shipzone_id
  FROM cohead
  WHERE (cohead_id=pSoheadid);

  INSERT INTO charass
        (charass_target_type, charass_target_id,
         charass_char_id, charass_value)
  SELECT charass_target_type, _soheadid,
         charass_char_id, charass_value
    FROM charass
   WHERE ((charass_target_type='SO')
     AND  (charass_target_id=pSoheadid));

  FOR _soitem IN
    SELECT *
    FROM coitem JOIN itemsite ON (itemsite_id=coitem_itemsite_id)
    WHERE ( (coitem_cohead_id=pSoheadid)
      AND   (coitem_status <> 'X')
      AND   (coitem_subnumber = 0) ) LOOP

    SELECT NEXTVAL('coitem_coitem_id_seq') INTO _soitemid;

    -- insert characteristics first so they can be copied to associated supply order
    INSERT INTO charass
          (charass_target_type, charass_target_id,
           charass_char_id, charass_value)
    SELECT charass_target_type, _soitemid,
           charass_char_id, charass_value
      FROM charass
     WHERE ((charass_target_type='SI')
       AND  (charass_target_id=_soitem.coitem_id));

    INSERT INTO coitem
    ( coitem_id,
      coitem_cohead_id,
      coitem_linenumber,
      coitem_itemsite_id,
      coitem_status,
      coitem_scheddate,
      coitem_promdate,
      coitem_qtyord,
      coitem_unitcost,
      coitem_price,
      coitem_custprice,
      coitem_qtyshipped,
      coitem_order_id,
      coitem_memo,
      coitem_imported,
      coitem_qtyreturned,
      coitem_closedate,
      coitem_custpn,
      coitem_order_type,
      coitem_close_username,
--      coitem_lastupdated,
      coitem_substitute_item_id,
      coitem_created,
      coitem_creator,
      coitem_prcost,
      coitem_qty_uom_id,
      coitem_qty_invuomratio,
      coitem_price_uom_id,
      coitem_price_invuomratio,
      coitem_warranty,
      coitem_cos_accnt_id,
      coitem_qtyreserved,
      coitem_subnumber,
      coitem_firm,
      coitem_taxtype_id )
    VALUES
    ( _soitemid,
      _soheadid,
      _soitem.coitem_linenumber,
      _soitem.coitem_itemsite_id,
      'O',
      COALESCE(pSchedDate, _soitem.coitem_scheddate),
      _soitem.coitem_promdate,
      _soitem.coitem_qtyord,
      stdCost(_soitem.itemsite_item_id),
      _soitem.coitem_price,
      _soitem.coitem_custprice,
      0.0,
      -1,
      _soitem.coitem_memo,
      FALSE,
      0.0,
      NULL,
      _soitem.coitem_custpn,
      _soitem.coitem_order_type,
      NULL,
--      NULL,
      _soitem.coitem_substitute_item_id,
      NULL,
      getEffectiveXtUser(),
      _soitem.coitem_prcost,
      _soitem.coitem_qty_uom_id,
      _soitem.coitem_qty_invuomratio,
      _soitem.coitem_price_uom_id,
      _soitem.coitem_price_invuomratio,
      _soitem.coitem_warranty,
      _soitem.coitem_cos_accnt_id,
      0.0,
      _soitem.coitem_subnumber,
      _soitem.coitem_firm,
      _soitem.coitem_taxtype_id );

  END LOOP;

  RETURN _soheadid;

END;
$$ LANGUAGE plpgsql;
