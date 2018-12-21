/*

10000000 (1) = no compression
01000000 (2) = BASIC/OLTP
00100000 (4) = QUERY HIGH
00010000 (8) = QUERY LOW
00001000 (16) = ARCHIVE HIGH
00000100 (32) = ARCHIVE LOW
*/

select 
decode(
DBMS_COMPRESSION.GET_COMPRESSION_TYPE ( 'RRS_CORE_DBO', 'TEST_HCC_0', 'AAA4XVABhAAAAvoAEV'), 
1, 'No Compression',
2, 'Basic/OLTP Compression', 
4, 'HCC Query High',
8, 'HCC Query Low',
16, 'HCC Archive High',
32, 'HCC Archive Low',
'Unknown Compression Level') compression_type
from dual;

select rowid from TEST_HCC_0 t;

declare                                                                            
        FOR_COMPRESSION        NUMBER;                                          
        DICT_OBJ_N             NUMBER;                                          
        DATA_OBJ_N             NUMBER;                                          
        RFNO                   NUMBER;                                          
        BLKNO                  NUMBER;                                          
        AFNO                   NUMBER;                                          
        ROWTYPE                NUMBER;                                          
        ROWNO                  NUMBER;                                          
        COMP_LEVEL             NUMBER;                                          
        SEG_COMPRESSION_INFO   NUMBER;                                          
  BEGIN                                                                         
     DBMS_ROWID.ROWID_INFO('AAA4XVABhAAAAvoAEV', ROWTYPE, DATA_OBJ_N, RFNO, BLKNO, ROWNO);
     dbms_output.put_line(rowtype);     
                                                                                
     IF ROWTYPE = 0 THEN                                                        
        SELECT DATA_OBJECT_ID INTO DATA_OBJ_N FROM DBA_OBJECTS WHERE OBJECT_NAME = :TABNAME AND OWNER = :OWNNAME;                                                                                                                                 
     END IF;                                                                    
     AFNO := DBMS_ROWID.ROWID_TO_ABSOLUTE_FNO(:ROW_ID, :OWNNAME, :TABNAME);        
     SELECT OBJECT_ID INTO DICT_OBJ_N FROM DBA_OBJECTS WHERE OBJECT_NAME = :TABNAME AND OWNER = :OWNNAME AND DATA_OBJECT_ID = DATA_OBJ_N;                                                                         
                                                                                
                                                                                
     --KDZCMPTYPE(DATA_OBJ_N, DICT_OBJ_N, RFNO, BLKNO, AFNO, ROWNO, COMP_LEVEL);  
                                                                                
     /*IF COMP_LEVEL = 1 THEN                                                     
        FOR_COMPRESSION := COMP_NOCOMPRESS;                                     
     ELSIF COMP_LEVEL = 2 THEN                                                  
        FOR_COMPRESSION := COMP_FOR_OLTP;                                       
     ELSIF COMP_LEVEL = 3 THEN                                                  
        FOR_COMPRESSION := COMP_FOR_QUERY_LOW;                                  
     ELSIF COMP_LEVEL = 4 THEN                                                  
        FOR_COMPRESSION := COMP_FOR_QUERY_HIGH;                                 
     ELSIF COMP_LEVEL = 5 THEN                                                  
        FOR_COMPRESSION := COMP_FOR_ARCHIVE_LOW;                                
     ELSIF COMP_LEVEL = 6 THEN                                                  
        FOR_COMPRESSION := COMP_FOR_ARCHIVE_HIGH;                               
     END IF;                                                                    
                                                                                
                                                                                
                                                                                
                                                                                
     SELECT SPARE1 INTO SEG_COMPRESSION_INFO FROM SYS.SEG$ WHERE HWMINCR = DATA_OBJ_N;                                                                          
                                                                                
     IF (BITAND(SEG_COMPRESSION_INFO, 536870912) = 536870912) AND FOR_COMPRESSION = COMP_FOR_OLTP THEN                                                                                                                                          
        FOR_COMPRESSION := COMP_BLOCK;                                          
     END IF;                                                                    
                                                                                
                                                                                
--     RETURN (FOR_COMPRESSION); */                                                 
  END;                                                                              